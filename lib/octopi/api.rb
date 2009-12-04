require 'singleton'
require File.join(File.dirname(__FILE__), "self")
module Octopi
  # Dummy class, so AnonymousApi and AuthApi have somewhere to inherit from
  class Api
    include Self
    attr_accessor :format, :login, :token, :trace_level, :read_only
  end
  
  # Used for accessing the Github API anonymously
  class AnonymousApi < Api
    include HTTParty
    include Singleton
    base_uri "http://github.com/api/v2"
    
    def read_only?
      true
    end
    
    def auth_parameters
      { }
    end
  end
  
  class AuthApi < Api
    include HTTParty
    include Singleton
    base_uri "https://github.com/api/v2"
    
    def read_only?
      false
    end
    
    def auth_parameters
      { :login => Api.me.login, :token => Api.me.token }
    end
  end
  
  # This is the real API class.
  #
  # API requests are limited to 60 per minute.
  #
  # Sets up basic methods for accessing the API.
  class Api
    @@api = Octopi::AnonymousApi.instance
    @@authenticated = false
    
    include Singleton
    CONTENT_TYPE = {
      'yaml' => ['application/x-yaml', 'text/yaml', 'text/x-yaml', 'application/yaml'],
      'json' => 'application/json',
      'xml'  => 'application/xml',
      # Unexpectedly, Github returns resources such as blobs as text/html!
      # Thus, plain == text/html.
      'plain' => ['text/plain', 'text/html']
    }  
    RETRYABLE_STATUS = [403]
    MAX_RETRIES = 10
    # Would be nice if cattr_accessor was available, oh well.
    
    # We use this to check if we use the auth or anonymous api
    def self.authenticated
      @@authenticated
    end
    
    # We set this to true when the user has auth'd.
    def self.authenticated=(value)
      @@authenticated = value
    end
    
    # The API we're using 
    def self.api
      @@api
    end
    
    class << self
      alias_method :me, :api
    end
    
    # set the API we're using
    def self.api=(value)
      @@api = value
    end


    def user
      user_data = get("/user/show/#{login}")
      raise "Unexpected response for user command" unless user_data and user_data['user']
      User.new(user_data['user'])
    end
  
    def save(resource_path, data)
      traslate resource_path, data
      #still can't figure out on what format values are expected
      post("#{resource_path}", { :query => data })
    end
  
    
    def find(path, result_key, resource_id, klass=nil, cache=true)      
      result = get(path, { :id => resource_id, :cache => cache }, klass) 
      result
    end
    
    
    def find_all(path, result_key, query, klass=nil, cache=true)
      { :query => query, :id => query, :cache => cache }
      result = get(path, { :query => query, :id => query, :cache => cache }, klass)
      result[result_key]
    end
  
    def get_raw(path, params, klass=nil)
     get(path, params, klass,  'plain')
    end
  
    def get(path, params = {}, klass=nil, format = :yaml)
      @@retries = 0
      begin
        submit(path, params, klass, format) do |path, params, format, query|
          self.class.get "/#{format}#{path}", { :format => format, :query => query }
        end
      rescue RetryableAPIError => e
        if @@retries < MAX_RETRIES
          $stderr.puts e.message
          if e.code != 403
            @@retries += 1
            sleep 6
            retry
          else
            raise APIError, "Github returned status #{e.code}, you may not have access to this resource."
          end
        else  
          raise APIError, "GitHub returned status #{e.code}, despite" +
           " repeating the request #{MAX_RETRIES} times. Giving up."
        end  
      end  
    end
  
    def post(path, params = {}, klass=nil, format = :yaml)
      @@retries = 0
      begin
        trace "POST", "/#{format}#{path}", params
        submit(path, params, klass, format) do |path, params, format, query|
          resp = self.class.post "/#{format}#{path}", { :body => params, :format => format, :query => query }
          resp
        end
      rescue RetryableAPIError => e
        if @@retries < MAX_RETRIES
          $stderr.puts e.message
          @@retries += 1
          sleep 6
          retry
        else
          raise APIError, "GitHub returned status #{e.code}, despite" +
           " repeating the request #{MAX_RETRIES} times. Giving up."
        end
      end
    end

    private
    
    def method_missing(method, *args)
      api.send(method, *args)
    end
    
    def submit(path, params = {}, klass=nil, format = :yaml, &block)
      # Ergh. Ugly way to do this. Find a better one!
      cache = params.delete(:cache) 
      cache = true if cache.nil?
      params.each_pair do |k,v|
        if path =~ /:#{k.to_s}/
          params.delete(k)
          path = path.gsub(":#{k.to_s}", v)
        end
      end
      begin
        key = "#{Api.api.class.to_s}:#{path}"
        resp = if cache
          APICache.get(key, :cache => 61) do
            yield(path, params, format, auth_parameters)
          end
        else
          yield(path, params, format, auth_parameters)
        end
      rescue Net::HTTPBadResponse
        raise RetryableAPIError
      end     
      
      raise RetryableAPIError, resp.code.to_i if RETRYABLE_STATUS.include? resp.code.to_i
      # puts resp.code.inspect
      raise NotFound, klass || self.class if resp.code.to_i == 404
      raise APIError, 
        "GitHub returned status #{resp.code}" unless resp.code.to_i == 200
      # FIXME: This fails for showing raw Git data because that call returns
      # text/html as the content type. This issue has been reported.
      
      # It happens, in tests.
      return resp if resp.headers.empty?
      ctype = resp.headers['content-type'].first.split(";").first
      raise FormatError, [ctype, format] unless CONTENT_TYPE[format.to_s].include?(ctype)
      if format == 'yaml' && resp['error']
        raise APIError, resp['error']
      end  
      resp
    end
    
    def trace(oper, url, params)
      return unless trace_level
      par_str = " params: " + params.map { |p| "#{p[0]}=#{p[1]}" }.join(", ") if params && !params.empty?
      puts "#{oper}: #{url}#{par_str}"
    end
    
  end
end