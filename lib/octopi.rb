require 'rubygems'
require 'httparty'
require 'yaml'
require 'pp'


Dir[File.join(File.dirname(__FILE__), "octopi/*.rb")].each { |f| require f }

module Octopi
  def authenticated(*args, &block)
    opts = args.last.is_a?(Hash) ? args.last : {}
    config = read_gitconfig
    login = config["github"]["user"]
    token = config["github"]["token"]
    
    api = AuthApi.new(login, token)
    api.trace_level = opts[:trace]
    
    puts "=> Trace on: #{api.trace_level}" if api.trace_level

    yield api
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
    
    api = AuthApi.new(login, token)
    api.trace_level = trace if trace
    yield api
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
  
  class AuthApi < Api
    include HTTParty
    base_uri "https://github.com/api/v2"
  end
    
  class AnonymousApi < Api
    include HTTParty
    base_uri "http://github.com/api/v2"
  end
  
  ANONYMOUS_API = AnonymousApi.new

end