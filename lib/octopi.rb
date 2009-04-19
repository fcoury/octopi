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

    def current_user
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
    
    def find(path, res, id)
      replace path, { :id => id }
      get(path)[res]
    end

    def find_all(path, res, query)
      replace path, { :query => query }
      get(path)[res]
    end
  
    private
    def replace(str, params)
      params.each_pair do |k,v|
        str.gsub!(":#{k.to_s}", v)
      end
    end
    
    def get(uri, format = "yaml")
      puts "GET: #{"/#{format}#{uri}"}"
      self.class.get("/#{format}#{uri}")
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
    
    def save
      hash = {}
      @keys.each { |k| hash[k] = send(k) }
      @api.save(self.path_for(:resource), hash)
    end
  end
  
  module Resource
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def set_resource_name(singular, plural = nil)
        @resource_name = singular
        @resources_name = plural || "#{singular}s"
      end
    
      def find_path(path)
        (@@path_spec||={})[:find] = path
      end
    
      def resource_path(path)
        (@@path_spec||={})[:resource] = path
      end
    
      def find(s)
        ANONYMOUS_API.find(path_for(:resource), self.resource_name, s)
      end
    
      def find_all(s)
        ANONYMOUS_API.find_all(path_for(:find), self.resources_name, s)
      end
    
      def resource_name
        @resource_name || (name.split('::').last || '').downcase 
      end
    
      def resources_name
        @resources_name || "#{resource_name}s"
      end
    
      private
      def path_for(type)
        "/#{resource_name}#{@@path_spec[type]}"
      end
    end
  end
  
  class User < Base
    include Resource
    
    find_path "/search/:query"
    resource_path "/show/:id"
  end
  
  class Repository < Base
    include Resource

    set_resource_name "repo"
    find_path "/search/:query"
    resource_path "/show/:user/:id"
  end
end