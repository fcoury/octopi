module Octopi
  class Commit < Base
    include Resource
    find_path "/commits/list/:query"
    resource_path "/commits/show/:id"
    
    attr_accessor :repository, :message, :parents, :author, :url, :id, :committed_date, :authored_date, :tree, :committer
    
    
    #Finds all commits for the given options:
    #
    # :repo or :repository or :name - A repository object or the name of a repository
    # :user - A user object or the login of a user
    # :branch - A branch object or the name of a branch. Defaults to master. 
    # 
    # Sample usage:
    #
    #   find_all(:user => "fcoury", :repo => "octopi") # branch defaults to master
    #   find_all(:user => "fcoury", :repo => "octopi", :branch => "lazy") # branch is set to lazy.
    #
    def self.find_all(opts={})
      # TODO: Refactor this into a helper method, is used elsewhere.
      repo = opts[:repository] || opts[:repo] || opts[:name]
      repo = Repository.find(:user => opts[:user], :name => repo) if !repo.is_a?(Repository)
      user = repo.owner.to_s
      user ||= opts[:user].to_s
      branch = opts[:branch] || "master"
      self.validate_args(user => :user, repo.name => :repo)
      commits = super user, repo.name, branch
      # TODO: Find out what this does, and why it's needed. 
      # commits.each { |c| c.repository = repo } if repo.is_a? Repository
      commits
    end
    
    # Finds a single commit based on the options given
    def self.find(opts={})
      if args.last.is_a?(Commit)
        commit = args.pop
        super "#{commit.repo_identifier}"
      else
        user, name, sha = *args
        user = user.login if user.is_a? User
        name = repo.name  if name.is_a? Repository
        self.validate_args(user => :user, name => :repo, sha => :sha)
        super [user, name, sha]
      end
    end
    
    def details
      self.class.find(self)
    end
    
    def repo_identifier
      url_parts = url.split('/')
      if @repository
        parts = [@repository.owner, @repository.name, url_parts[6]] 
      else
        parts = [url_parts[3], url_parts[4], url_parts[6]]
      end
      
      parts.join('/')
    end
  end
end
