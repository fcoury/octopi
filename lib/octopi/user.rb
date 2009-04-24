module Octopi
  class User < Base
    include Resource
    
    find_path "/user/search/:query"
    resource_path "/user/show/:id"
    
    def self.find(username)
      self.validate_args(username => :user)
      super username
    end

    def self.followers(username)
      self.validate_args(username => :user)
      self.property('followers', username).map{|u| LazyUser.new u}
    end

    def self.following(username)
      self.validate_args(username => :user)
      self.property('following', username).map{|u| LazyUser.new u}
    end

    def self.find_all(username)
      self.validate_args(username => :user)
      super username
    end

    def repositories
      Repository.find_by_user(login)
    end
    
    def repository(name)
      self.class.validate_args(name => :repo)
      Repository.find(login, name)
    end

  end
end
