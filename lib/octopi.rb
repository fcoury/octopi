#stdlib
require 'pathname'

#gems
require 'httparty'
require 'json'
require 'active_support/core_ext/hash/keys'

module Octopi
  autoload :Base, "octopi/base"
  autoload :Collections, "octopi/collections"
  autoload :Gist, "octopi/gist"
  autoload :Organization, "octopi/organization"
  autoload :Repo, "octopi/repo"
  autoload :User, "octopi/user"
  
  class NotAuthenticated < StandardError
    def message
     "You must authenticate before accessing this resource. Use Octopi.authenticate!(:username => 'username', :password => 'password') to do this."
    end
  end
  
  include HTTParty
  base_uri "https://api.github.com"

  def self.authenticate!(opts={})
    self.basic_auth(opts[:username], opts[:password])
    if get("/").response.code == "302"
      @username = opts[:username]
      @password = opts[:password]
      return true
    else
      raise "Authentication failed."
    end
  end

  # Used to stop API calls in their tracks when they require authentication
  # and authentication credentials have not yet been provided  
  def self.requires_authentication!
    if @username.nil? || @password.nil?
      raise NotAuthenticated
    else
      self.basic_auth(@username, @password)
      yield
    end
  end

  # Unauthenticates all future requests, until #authenticate! is called again
  def self.logout!
    @username, @password = nil, nil
    basic_auth(@username, @password)
  end

  # Returns the username set by #authenticate!
  def self.username
    @username
  end
  
  def self.username=(username)
    @username = username
  end
  
  # Returns the password set by #authenticate!
  def self.password
    @password
  end
  
  def self.password=(password)
    @password = password
  end
end