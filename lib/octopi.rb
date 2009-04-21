require 'rubygems'
require 'httparty'
require 'yaml'
require 'pp'

module Octopi
  class Api; end
  ANONYMOUS_API = Api.new
  
  def authenticated_with(*args, &block)
    opts = args.last.is_a?(Hash) ? args.last : {}
    if opts[:config]
      config = File.open(opts[:config]) { |yf| YAML::load(yf) }
      raise "Missing config #{opts[:config]}" unless config
      
      login = config["login"]
      token = config["token"]
      trace = config["trace"]
    else
      login, token = *args
    end
    
    puts "=> Trace on: #{trace}" if trace
    
    api = Api.new(login, token)
    api.trace = trace if trace
    yield api
  end
  
  class Api
    include HTTParty
    CONTENT_TYPE = {
      'yaml' => 'application/x-yaml',
      'json' => 'application/json',
      'xml'  => 'application/sml'
    }  
    base_uri "http://github.com/api/v2"
  
    attr_accessor :format, :login, :token, :trace, :read_only
  
    def initialize(login = nil, token = nil, format = "yaml")
      @format = format
      @read_only = true
      
      if login
        @login = login
        @token = token
        @read_only = false
      end
    end
  
    %w[keys emails].each do |action|
      define_method("#{action}") do
        get("/user/#{action}")
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
      repo = Repository.find(login, name)
      repo.api = self
      repo
    end
    alias_method :repo, :repository
    
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
    
    def post(path, params = {}, format = "yaml")
      trace "POST", path, params
      submit(path, params, format) do |path, params, format|
        resp = self.class.post "/#{format}#{path}", :query => params
        resp
      end
    end

    private
    def submit(path, params = {}, format = "yaml", &block)
      params.each_pair { |k,v| path = path.gsub(":#{k.to_s}", v) }
      query = login ? { :login => login, :token => token } : {}
      query.merge!(params)
      
      if @trace
        case @trace
          when "curl"
            query_trace = []
            query.each_pair { |k,v| query_trace << "-F '#{k}=#{v}'" }
            puts "===== [curl version]"
            puts "curl #{query_trace.join(" ")} #{self.class.base_uri}#{path}"
            puts "==================="
        end
      end
      
      resp = yield(path, query, format)
      raise APIError, 
        "GitHub returned status #{resp.code}" unless resp.code.to_i == 200
      # FIXME: This fails for showing raw Git data because that call returns
      # text/html as the content type. This issue has been reported.
      ctype = resp.headers['content-type'].first
      raise FormatError, [ctype, format] unless 
        ctype.match(/^#{CONTENT_TYPE[format]};/)
      if format == 'yaml' && resp['error']
        raise APIError, resp['error'].first['error']
      end  
      resp
    end
    
    def get(path, params = {}, format = "yaml")
      trace "GET", path, params
      submit(path, params, format) do |path, params, format|
        self.class.get "/#{format}#{path}"
      end
    end
    
    def trace(oper, url, params)
      return unless @trace
      par_str = " params: " + params.map { |p| "#{p[0]}=#{p[1]}" }.join(", ") if params and !params.empty?
      puts "#{oper}: #{url}#{par_str}"
    end
  end
    
  %w{error base resource user tag repository issue file_object blob commit}.
    each{|f| require "#{File.dirname(__FILE__)}/octopi/#{f}"} 

end
