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
    
    def add_key(title, key)
      raise APIError, 
        "To add a key, you must be authenticated" if @api.read_only?

      result = @api.post("/user/key/add", :title => title, :key => key)
      return if !result["public_keys"]
      key_params = result["public_keys"].select { |k| k["title"] == title }
      return if !key_params or key_params.empty?
      Key.new(@api, key_params.first, self)
    end

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
