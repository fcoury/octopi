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
      get(path, { :query => query })[result_key]
    end
  
    private
    def get(path, params = {}, format = "yaml")
      params.each_pair do |k,v|
        path = path.gsub(":#{k.to_s}", v)
      end
      # puts "GET: /#{format}#{path}"
      self.class.get("/#{format}#{path}")
    end
  end
  
  class Base
    def initialize(api, hash)
      @api = api
      @keys = []
      
      raise "Missing data for #{@resource}" unless hash
      
      hash.each_pair do |k,v|
        @keys << k
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
        result = ANONYMOUS_API.find(path_for(:resource), @resource_name[:singular], s)
        key = result.keys.first
        Resource.for(key).new(ANONYMOUS_API, result[key])
      end
      
      def find_all(s)
        all = []
        result = ANONYMOUS_API.find_all(path_for(:find), @resource_name[:plural], s)
        result.each do |item|
          all << new(ANONYMOUS_API, item)
        end
        all
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
    
    def user_property(property, deep)
      users = []
      property(property, login).each_pair do |k,v|
        return v unless deep
        
        v.each { |u| users << User.find(u) } 
      end
      
      users
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
  end
  
  class Repository < Base
    include Resource
    set_resource_name "repository", "repositories"

    find_path "/repos/search/:query"
    resource_path "/repos/show/:id"

    def self.find(user, name)
      super "#{user}/#{name}"
    end
    
    def self.find_all(*args)
      super args.join("+")
    end
    
    def commits(branch = "master")
      Commit.find_all(owner, name, branch, self)
    end
  end
  
  class Commit < Base
    include Resource
    find_path "/commits/list/:query"
    resource_path "/commits/show/:id"
    
    attr_accessor :repository
    
    def self.find_all(user, name, branch = "master", repo = nil)
      commits = super("#{user}/#{name}/#{branch}")
      commits.each { |c| c.repository = repo } if repo
      commits
    end
    
    def self.find(*args)
      if args.last.is_a?(Commit)
        commit = args.pop
        super "#{commit.repo_identifier}"
      else
        user, name, sha = *args
        super "#{user}/#{name}/#{sha}"
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
end