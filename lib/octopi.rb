require 'rubygems'
require 'httparty'
require 'pp'

module Octopi
  class Api; end
  ANONYMOUS_API = Api.new
  
  def connect(login, token, &block)
    yield Api.new(login, token)
  end
  
  class Api
    include HTTParty
    base_uri "http://github.com/api/v2"
  
    attr_accessor :format
  
    def initialize(login = nil, token = nil, format = "xml")
      self.class.default_params(:login => login, :token => token) if login
      @format = format
    end
  
    %w[keys emails].each do |action|
      define_method("#{action}") do
        get("/user/#{action}")
      end
    end

    def user
      user_data = get("/user/show/#{self.class.default_params[:login]}")
      raise "Unexpected response for user command" unless user_data and user_data['user']
      User.new(self, user_data['user'])
    end
    
    def save(resource_path, data)
      traslate resource_path, data
      #still can't figure out on what format values are expected
      post("#{resource_path}", { :query => data })
    end
    
    def find(path, result_key, resource_id)
      get(path, { :id => resource_id }) 
    end

    def find_all(path, result_key, query)
      get(path, { :query => query, :id => query })[result_key]
    end
    def get_raw(path, params)
     get(path, params, 'plain')
    end

    private
    def get(path, params = {}, format = "yaml")
      params.each_pair do |k,v|
        path = path.gsub(":#{k.to_s}", v)
      end
      resp = self.class.get("/#{format}#{path}")
      raise APIError, 
        "GitHub returned status #{resp.code}" unless resp.code == 200
      if format == 'yaml' && resp['error']
        raise APIError, resp['error'].first['error']
      end  
      resp
    end
  end
  
  class Base
    def initialize(api, hash)
      @api = api
      @keys = []
      
      raise "Missing data for #{@resource}" unless hash
      
      hash.each_pair do |k,v|
        @keys << k
        next if k =~ /\./
        instance_variable_set("@#{k}", v)
        
        self.class.send :define_method, "#{k}=" do |v|
          instance_variable_set("@#{k}", v)
        end

        self.class.send :define_method, k do
          instance_variable_get("@#{k}")
        end
      end
    end
    
    def property(p, v)
      path = "#{self.class.path_for(:resource)}/#{p}"
      @api.find(path, self.class.resource_name(:singular), v)
    end
    def save
      hash = {}
      @keys.each { |k| hash[k] = send(k) }
      @api.save(self.path_for(:resource), hash)
    end
  end
  
  module Resource
    def self.included(base)
      base.extend ClassMethods
      base.set_resource_name(base.name)
      (@@resources||={})[base.resource_name(:singular)] = base
      (@@resources||={})[base.resource_name(:plural)] = base
    end
    
    def self.for(name)
      @@resources[name]
    end
    
    module ClassMethods
      def set_resource_name(singular, plural = "#{singular}s")
        @resource_name = {:singular => declassify(singular), :plural => declassify(plural)}
      end
      
      def resource_name(key)
        @resource_name[key]
      end
      
      def declassify(s)
        (s.split('::').last || '').downcase if s
      end
    
      def find_path(path)
        (@path_spec||={})[:find] = path
      end
    
      def resource_path(path)
        (@path_spec||={})[:resource] = path
      end
    
      def find(s)
        s = s.join('/') if s.is_a? Array
        result = ANONYMOUS_API.find(path_for(:resource), @resource_name[:singular], s)
        key = result.keys.first
        if result[key].is_a? Array
          result[key].map do |r|
            new(ANONYMOUS_API, r)
          end  
        else  
          Resource.for(key).new(ANONYMOUS_API, result[key])
        end  
      end
      
      def find_all(s)
        find_plural(s, :find)
      end

      def find_plural(s,path)
        s = s.join('/') if s.is_a? Array
        ANONYMOUS_API.find_all(path_for(path), @resource_name[:plural], s).
          map do |item|
            payload = block_given? ? yield(item) : item
            new(ANONYMOUS_API, payload)
          end
      end
      
      def path_for(type)
        @path_spec[type]
      end
    end
  end
  
  class User < Base
    include Resource
    
    find_path "/user/search/:query"
    resource_path "/user/show/:id"
    
    def repositories
      Repository.find_by_user(login)
    end
    
    def repository(name)
      Repository.find(login, name)
    end
    
    # takes one param, deep that indicates if returns 
    # only the user login or an user object
    %w[followers following].each do |method|
      define_method(method) do
        user_property(method, false)
      end
      define_method("#{method}!") do
        user_property(method, true)
      end
    end
    
    def user_property(property, deep)
      users = []
      property(property, login).each_pair do |k,v|
        return v unless deep
        
        v.each { |u| users << User.find(u) } 
      end
      
      users
    end
  end
  
  class Tag < Base
    include Resource
    set_resource_name "tag"

    resource_path "/repos/show/:id"
    
    def self.find(user, repo)
      user = user.login if user.is_a? User
      repo = repo.name if repo.is_a? Repository
      find_plural([user,repo,'tags'], :resource){
        |i| {:name => i.first, :hash => i.last }
      }
    end
  end

  class Repository < Base
    include Resource
    set_resource_name "repository", "repositories"

    find_path "/repos/search/:query"
    resource_path "/repos/show/:id"

    def tags
      Tag.find(self.owner, self.name)
    end  
    
    def clone_url
      #FIXME: Return "git@github.com:#{self.owner}/#{self.name}.git" if
      #user's logged in and owns this repo.
      "git://github.com/#{self.owner}/#{self.name}.git"  
    end

    def self.find_by_user(user)
      user = user.login if user.is_a? User
      find_plural(user, :resource)
    end

    def self.find(user, name)
      user = user.login if user.is_a? User
      name = repo.name if name.is_a? Repository
      super [user,name]
    end

    def self.find_all(*args)
      # FIXME: This should be URI escaped, but have to check how the API
      # handles escaped characters first.
      super args.join(" ").gsub(/ /,'+')
    end
    
    def commits(branch = "master")
      Commit.find_all(owner, name, branch, self)
    end
  end
  
  class FileObject < Base
    include Resource
    set_resource_name "tree"

    resource_path "/tree/show/:id"

    def self.find(user, repo, sha)
      user = user.login if user.is_a? User
      repo = repo.name if repo.is_a? Repository
      super [user,repo,sha] 
    end  
  end
  
  class Blob < Base
    include Resource
    set_resource_name "blob"

    resource_path "/blob/show/:id"

    def self.find(user, repo, sha, path=nil)
      user = user.login if user.is_a? User
      repo = repo.name if repo.is_a? Repository
      if path
        super [user,repo,sha,path]
      else
        blob = ANONYMOUS_API.get_raw(path_for(:resource), 
              {:id => [user,repo,sha].join('/')})
        new(ANONYMOUS_API, {:text => blob})
      end  
    end  
  end
  class Commit < Base
    include Resource
    find_path "/commits/list/:query"
    resource_path "/commits/show/:id"
    
    attr_accessor :repository
    
    def self.find_all(user, name, branch = "master", repo = nil)
      user = user.login if user.is_a? User
      repo = repo.name  if repo.is_a? Repository
      name = repo.name  if name.is_a? Repository
      commits = super [user, name, branch]
      commits.each { |c| c.repository = repo } if repo
      commits
    end
    
    def self.find(*args)
      if args.last.is_a?(Commit)
        commit = args.pop
        super "#{commit.repo_identifier}"
      else
        user, name, sha = *args
        user = user.login if user.is_a? User
        name = repo.name  if name.is_a? Repository
        super [user, name, sha]
      end
    end
    
    def details
      self.class.find(self)
    end
    
    def repo_identifier
      url_parts = url.split('/')
      if @repository
        parts = [@repository.owner, @repository.name, url_parts[6]] 
      else
        parts = [url_parts[3], url_parts[4], url_parts[6]]
      end
      
      puts parts.join('/')
      parts.join('/')
    end
  end
  class APIError < StandardError
   def initialize(m)
     $stderr.puts m 
   end
  end 
end
