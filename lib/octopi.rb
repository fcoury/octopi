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
    CONTENT_TYPE = {
      'yaml' => 'application/x-yaml',
      'json' => 'application/json',
      'xml'  => 'application/sml'
    }  
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
      # FIXME: This fails for showing raw Git data because that call returns
      # text/html as the content type. This issue has been reported.
      ctype = resp.headers['content-type'].first
      raise FormatError, [ctype, format] unless 
        ctype.match(/^#{CONTENT_TYPE[format]};/)
      raise APIError, 
        "GitHub returned status #{resp.code}" unless resp.code.to_i == 200
      if format == 'yaml' && resp['error']
        raise APIError, resp['error'].first['error']
      end  
      resp
    end
  end
    
  %w{error base resource user tag repository issue file_object blob commit}.
    each{|f| require "#{File.dirname(__FILE__)}/octopi/#{f}"} 

end
