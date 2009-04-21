module Octopi
  class User < Base
    include Resource
    
    find_path "/user/search/:query"
    resource_path "/user/show/:id"
    
    def self.find(username)
      self.validate_args(username => :user)
      super username
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
    
    # takes one param, deep that indicates if returns 
    # only the user login or an user object
    %w[followers following].each do |method|
      define_method(method) do
        user_property(method, false)
      end
      define_method("#{method}!") do
        user_property(method, true)
      end
    end
    
    def user_property(property, deep)
      users = []
      property(property, login).each_pair do |k,v|
        return v unless deep
        
        v.each { |u| users << User.find(u) } 
      end
      
      users
    end
  end
end
