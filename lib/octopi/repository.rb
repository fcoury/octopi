  class Repository < Base
    include Resource
    set_resource_name "repository", "repositories"

    find_path "/repos/search/:query"
    resource_path "/repos/show/:id"

    def tags
      Tag.find(self.owner, self.name)
    end  
    
    def clone_url
      #FIXME: Return "git@github.com:#{self.owner}/#{self.name}.git" if
      #user's logged in and owns this repo.
      "git://github.com/#{self.owner}/#{self.name}.git"  
    end

    def self.find_by_user(user)
      user = user.login if user.is_a? User
      find_plural(user, :resource)
    end

    def self.find(user, name)
      user = user.login if user.is_a? User
      name = repo.name if name.is_a? Repository
      super [user,name]
    end

    def self.find_all(*args)
      # FIXME: This should be URI escaped, but have to check how the API
      # handles escaped characters first.
      super args.join(" ").gsub(/ /,'+')
    end
    
    def commits(branch = "master")
      Commit.find_all(owner, name, branch, self)
    end
  end
