require 'singleton'
module Octopi
  # Dummy class, so AnonymousApi and AuthApi have somewhere to inherit from
  class Api
    
  end
  
  class AnonymousApi < Api
    include HTTParty
    base_uri "http://github.com/api/v2"
  end
  
  class AuthApi < Api
    include HTTParty
    base_uri "https://github.com/api/v2"
  end
  
  # This is the real API class
  class Api
    @@api = Octopi::AnonymousApi.new
    @@authenticated = false
    
    include Singleton
    CONTENT_TYPE = {
      'yaml' => 'application/x-yaml',
      'json' => 'application/json',
      'xml'  => 'application/sml'
    }  
    RETRYABLE_STATUS = [403]
    MAX_RETRIES = 10
    
    attr_accessor :format, :login, :token, :trace_level, :read_only
    
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
    
    # set the API we're using
    def self.api=(value)
      @@api = value
    end

    def self.new(login = nil, token = nil, format = "yaml")
      @format = format
      @read_only = true
    
      if login
        @login = login
        @token = token
        @read_only = false
        default_params :login => login, :token => token
      end
    end

    def read_only?
      read_only
    end

    {:keys => 'public_keys', :emails => 'emails'}.each_pair do |action, key|
      define_method("#{action}") do
        get("/user/#{action}")[key]
      end
    end

    def user
      user_data = get("/user/show/#{login}")
      raise "Unexpected response for user command" unless user_data and user_data['user']
      User.new(self, user_data['user'])
    end
  
    def open_issue(user, repo, params)
      Issue.open(user, repo, params, self)
    end
  
    def repository(name)
      repo = Repository.find(user, name, self)
      repo.api = self
      repo
    end
    alias_method :repo, :repository
  
    def commits(repo,opts={})
      branch = opts[:branch] || "master"
      commits = Commit.find_all(repo, branch, self)
    end
  
    def save(resource_path, data)
      traslate resource_path, data
      #still can't figure out on what format values are expected
      post("#{resource_path}", { :query => data })
    end
    
    # TODO: It would be preferrable if this method took a set of args, rather than an options hash
    def find(path, result_key, resource_id)
      get(path, { :id => resource_id }) 
    end
    
    
    def find_all(path, result_key, query)
      get(path, { :query => query, :id => query })[result_key]
    end
  
    def get_raw(path, params)
     get(path, params, 'plain')
    end
  
    def get(path, params = {}, format = "yaml")
      @@retries = 0
      begin
        trace "GET [#{format}]", "/#{format}#{path}", params
        submit(path, params, format) do |path, params, format|
          self.class.get "/#{format}#{path}"
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
  
    def post(path, params = {}, format = "yaml")
      @@retries = 0
      begin
        trace "POST", "/#{format}#{path}", params
        submit(path, params, format) do |path, params, format|
          resp = self.class.post "/#{format}#{path}", :body => params
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
    def submit(path, params = {}, format = "yaml", &block)
      params.each_pair do |k,v|
        if path =~ /:#{k.to_s}/
          params.delete(k)
          path = path.gsub(":#{k.to_s}", v)
        end
      end
      query = login ? { :login => login, :token => token } : {}
      query.merge!(params)
    
      begin
        resp = yield(path, query.merge(params), format)
      rescue Net::HTTPBadResponse
        raise RetryableAPIError
      end
    
      if @trace_level
        case @trace_level
          when "curl"
            query_trace = []
            query.each_pair { |k,v| query_trace << "-F '#{k}=#{v}'" }
            puts "===== [curl version]"
            puts "curl #{query_trace.join(" ")} #{self.class.base_uri}/#{format}#{path}"
            puts "===================="
        end
      end
      raise RetryableAPIError, resp.code.to_i if RETRYABLE_STATUS.include? resp.code.to_i
      raise APIError, 
        "GitHub returned status #{resp.code}" unless resp.code.to_i == 200
      # FIXME: This fails for showing raw Git data because that call returns
      # text/html as the content type. This issue has been reported.
      
      # It happens, in tests.
      return resp if resp.headers.empty?
      ctype = resp.headers['content-type'].first
      raise FormatError, [ctype, format] unless 
        ctype.match(/^#{CONTENT_TYPE[format]};/)
      if format == 'yaml' && resp['error']
        raise APIError, resp['error'].first['error']
      end  
      resp
    end
  
    def trace(oper, url, params)
      return unless trace_level
      par_str = " params: " + params.map { |p| "#{p[0]}=#{p[1]}" }.join(", ") if params and !params.empty?
      puts "#{oper}: #{url}#{par_str}"
    end
  end
end