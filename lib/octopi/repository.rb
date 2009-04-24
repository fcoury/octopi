module Octopi
  class Repository < Base
    include Resource
    set_resource_name "repository", "repositories"

    find_path "/repos/search/:query"
    resource_path "/repos/show/:id"

    def self.branches(owner, name)
      Branch.find(owner,name)
    end              
    
    def self.tags(owner, name)
      Tag.find(owner, name)
    end  
  
    def clone_url
      #FIXME: Return "git@github.com:#{self.owner}/#{self.name}.git" if
      #user's logged in and owns this repo.
      "git://github.com/#{self.owner}/#{self.name}.git"  
    end

    def self.find_by_user(user)
      user = user.login if user.is_a? User
      self.validate_args(user => :user)
      find_plural(user, :resource)
    end

    def self.find(*args)
      api = args.last.is_a?(Api) ? args.pop : ANONYMOUS_API
      repo = args.pop
      user = args.pop
      
      user = user.login if user.is_a? User
      if repo.is_a? Repository
        repo = repo.name 
        user ||= repo.owner 
      end
      
      self.validate_args(user => :user, repo => :repo)
      super user, repo, api
    end

    def self.find_all(*args)
      # FIXME: This should be URI escaped, but have to check how the API
      # handles escaped characters first.
      super args.join(" ").gsub(/ /,'+')
    end
    
    def self.open_issue(*args)
      return Issue.open(*args) unless Hash === args
      Issue.open(args[:user], args[:repo], args)
    end
    
    #def open_issue(args)
    #  Issue.open(self.owner, self, args, @api)
    #end
    
    def self.commits(user, repo, branch = "master")
      Commit.find_all(:user => user, :repo => repo, :branch => branch)
    end
    
    def self.issues(user, repo, state = "open")
      Issue.find_all(:user => user, :repo => repo, :state => state)
    end
   
    def self.all_issues(user, repo)
      Issue::STATES.map{|state| self.issues(user, repo, state)}.flatten
    end

    def self.issue(user, repo, number)
      Issue.find(user, repo, number)
    end

    def self.collaborators(user, repo)
      self.property('collaborators', [user, repo].join('/')).
           map{ |c| LazyUser.new c }
    end  

    # The GitHub API uses inconsistent naming for key fields in the response.
    # repos/show uses :owner to refer to the repository's owner, while
    # repos/search uses :username. We use this convoluted approach to define
    # this alias so we don't step on anything else that defines methods
    # automatically.
    def method_missing(method,*args)
      if self.respond_to?(:username) && method == :owner
        return self.username
      else
        super method, *args
      end
    end  
  end
end
