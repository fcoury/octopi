module Octopi
  class User < Base
    include Resource
    attr_accessor :company, :name, :following_count, :blog, :public_repo_count, :public_gist_count, :id, :login, :followers_count, :created_at, :email, :location, :disk_usage, :private_repo_count, :private_gist_count, :collaborators, :plan, :owned_private_repo_count, :total_private_repo_count
    
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
      self.class.validate_hash(options)
      Repository.find({ :user => login }.merge!(options))
    end
    
    def create_repository(name, opts = {})
      self.class.validate_args(name => :repo)
      Repository.create(self, name, opts)
    end

    # Returns a list of Key objects containing all SSH Public Keys this user
    # currently has. Requires authentication.
    def keys
      raise APIError, "To view keys, you must be authenticated" if Api.api.read_only?

      result = Api.api.get("/user/keys")
      return unless result and result["public_keys"]
      KeySet.new(result["public_keys"].inject([]) { |result, element| result << Key.new(element) })
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
    
    # If a user object is passed into a method, we can use this.
    # It'll also work if we pass in just the login.
    def to_s
      login
    end
  end
end
