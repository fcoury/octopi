module Octopi
  class User < Base
    include Resource
    
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
      Repository.find_by_user(login)
    end
    
    # Searches for user Repository identified by
    # name
    def repository(name)
      self.class.validate_args(name => :repo)
      Repository.find(login, name)
    end
    
    def create_repository(name, opts = {})
      self.class.validate_args(name => :repo)
      Repository.create(self, name, opts)
    end
    
    # Adds an SSH Public Key to the user. Requires
    # authentication.
    def add_key(title, key)
      raise APIError, 
        "To add a key, you must be authenticated" if @api.read_only?

      result = @api.post("/user/key/add", :title => title, :key => key)
      return if !result["public_keys"]
      key_params = result["public_keys"].select { |k| k["title"] == title }
      return if !key_params or key_params.empty?
      Key.new(@api, key_params.first, self)
    end

    # Returns a list of Key objects containing all SSH Public Keys this user
    # currently has. Requires authentication.
    def keys
      raise APIError, 
        "To add a key, you must be authenticated" if @api.read_only?

      result = @api.get("/user/keys")
      return unless result and result["public_keys"]
      result["public_keys"].inject([]) { |result, element| result << Key.new(@api, element) }
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
