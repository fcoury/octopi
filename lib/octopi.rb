require 'rubygems'
require 'httparty'
require 'nokogiri'
require 'yaml'
require 'pp'


# Octopi stuff
Dir[File.join(File.dirname(__FILE__), "octopi/*.rb")].each { |f| require f }

module Octopi
  
  def authenticated(*args, &block)
    opts = args.last.is_a?(Hash) ? args.last : {}
    config = read_gitconfig
    login = config["github"]["user"]
    token = config["github"]["token"]
    Api.authenticated = true
    Api.api = AuthApi.new(login, token)
    Api.api.trace_level = opts[:trace]
    
    puts "=> Trace on: #{api.trace_level}" if Api.api.trace_level

    result = yield Api.api
    
    # Reset authenticated so if we were to do an anonymous call it would Just Work(tm)
    Api.authenticated = false
    Api.api = AnonymousApi.instance
    
    # Return the result
    result
  end
  
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
    
    Api.api = AuthApi.instance
    Api.api.login = login
    Api.api.token = token
    Api.api.trace_level = trace if trace
    
    result = yield Api.api
    
    # Reset authenticated so if we were to do an anonymous call it would Just Work(tm)
    Api.authenticated = false
    Api.api = AnonymousApi.instance
    
    # Return the result
    result
  end
  
  def read_gitconfig
    config = {}
    group = nil
    File.foreach("#{ENV['HOME']}/.gitconfig") do |line|
      line.strip!
      if line[0] != ?# and line =~ /\S/
        if line =~ /^\[(.*)\]$/
          group = $1
        else
          key, value = line.split("=")
          value ||= ''
          (config[group]||={})[key.strip] = value.strip
        end
      end
    end
    config
  end
end