require 'rubygems'
require 'httparty'
require 'nokogiri'
require 'yaml'
require 'pp'


# Octopi stuff
Dir[File.join(File.dirname(__FILE__), "octopi/*.rb")].each { |f| require f }

module Octopi
  
  def authenticated(*args, &block)
    begin
      opts = args.last.is_a?(Hash) ? args.last : {}
      config = read_gitconfig
      Api.authenticated = true
      Api.api = AuthApi.instance
      Api.api.login = config["github"]["user"]
      Api.api.token = config["github"]["token"]
      Api.api.trace_level = opts[:trace]
    
      puts "=> Trace on: #{api.trace_level}" if Api.api.trace_level

      yield Api.api
    ensure
      # Reset authenticated so if we were to do an anonymous call it would Just Work(tm)
      Api.authenticated = false
      Api.api = AnonymousApi.instance
    end
  end
  
  def authenticated_with(*args, &block)
    begin
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
    
      yield Api.api
    ensure
      # Reset authenticated so if we were to do an anonymous call it would Just Work(tm)
      Api.authenticated = false
      Api.api = AnonymousApi.instance
    end
  end
  
  def read_gitconfig
    config = {}
    group = nil
    File.foreach("#{ENV['HOME']}/.gitconfig") do |line|
      line.strip!
      if line[0] != ?# && line =~ /\S/
        if line =~ /^\[(.*)\]$/
          group = $1
          config[group] ||= {}
        else
          key, value = line.split("=").map { |v| v.strip }
          config[group][key] = value
        end
      end
    end
    config
  end
end