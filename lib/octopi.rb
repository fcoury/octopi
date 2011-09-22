#stdlib
require 'pathname'

#gems
require 'httparty'
require 'json'

module Octopi
  autoload :Base, "octopi/base"
  autoload :Gist, "octopi/gist"
  autoload :Repository, "octopi/repository"
  autoload :Repo, "octopi/repository"
  autoload :User, "octopi/user"
  
  include HTTParty

  def self.authenticate!(opts={})
    self.basic_auth(opts[:username], opts[:password])
    if get(base_url).response.code == "302"
      @username = opts[:username]
      @password = opts[:password]
      return true
    else
      raise "Authentication failed."
      return false
    end
  end
  
  def self.base_url
    "https://api.github.com"
  end

  # Returns the username set by #authenticate!
  def self.username
    @username
  end
  
  # Returns the password set by #authenticate!
  def self.password
    @password
  end
end