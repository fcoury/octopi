module Octopi
  class User < Base
    include Resource
    attr_accessor :company, :name, :following_count, :gravatar_id,
                  :blog, :public_repo_count, :public_gist_count, 
                  :id, :login, :followers_count, :created_at, 
                  :email, :location, :disk_usage, :private_repo_count, 
                  :private_gist_count, :collaborators, :plan, 
                  :owned_private_repo_count, :total_private_repo_count, 
                  
                  # These come from search results, which doesn't 
                  # contain the above information.
                  :actions, :score, :language, :followers, :following,
                  :fullname, :type, :username, :repos, :pushed, :created
    
    def plan=(attributes={})
      @plan = Plan.new(attributes)
    end
    
    find_path "/user/search/:query"
    resource_path "/user/show/:id"
    
    # Finds a single user identified by the given username
    #
    # Example:
    #   
    #   user = User.find("fcoury")
    #   puts user.login # should return 'fcoury'
    def self.find(username)
      self.validate_args(username => :user)
      super username
    end

    # Finds all users whose username matches a given string
    # 
    # Example:
    #
    #   User.find_all("oe") # Matches joe, moe and monroe
    #
    def self.find_all(username)
      self.validate_args(username => :user)
      super username
    end
    
    class << self
      alias_method :search, :find_all
    end

    # Returns a collection of Repository objects, containing
    # all repositories of the user.
    #
    # If user is the current authenticated user, some
    # additional information will be provided for the
    # Repositories.
    def repositories
      rs = RepositorySet.new(Repository.find(:user => self.login))
      rs.user = self
      rs
    end
    
    # Searches for user Repository identified by name
    def repository(options={})
      options = { :name => options } if options.is_a?(String)
      self.class.ensure_hash(options)
      Repository.find({ :user => login }.merge!(options))
    end
    
    def create_repository(name, options = {})
      self.class.validate_args(name => :repo)
      Repository.create(self, name, options)
    end
    
    def watching
      repositories = []
      Api.api.get("/repos/watched/#{login}")["repositories"].each do |repo|
        repositories << Repository.new(repo)
      end
      repositories
    end
    

    # Gets a list of followers.
    # Returns an array of logins.
    def followers
      user_property("followers")
    end

    # Gets a list of followers.
    # Returns an array of user objects.
    # If user has a large number of followers you may be rate limited by the API.
    def followers!
      user_property("followers", true)
    end

    # Gets a list of people this user is following.
    # Returns an array of logins.
    def following
      user_property("following")
    end

    # Gets a list of people this user is following.
    # Returns an array of user objectrs.
    # If user has a large number of people whom they follow, you may be rate limited by the API.
    def following!
      user_property("following", true)
    end

    
    # If a user object is passed into a method, we can use this.
    # It'll also work if we pass in just the login.
    def to_s
      login
    end
    
    private
    
    # Helper method for "deep" finds.
    # Determines whether to return an array of logins (light) or user objects (heavy).
    def user_property(property, deep=false)
      users = []
      property(property, login).each_pair do |k,v|
        return v unless deep
        
        v.each { |u| users << User.find(u) } 
      end
      
      users
    end
    
  end
end
