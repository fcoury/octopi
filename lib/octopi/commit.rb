module Octopi
  class Commit < Base
    include Resource
    find_path "/commits/list/:query"
    resource_path "/commits/show/:id"
    
    attr_accessor :repository, :message, :parents, :author, :url, :id, :committed_date, :authored_date, :tree, :committer, :added, :removed, :modified
    
    
    # Finds all commits for the given options:
    #
    # :repo or :repository or :name - A repository object or the name of a repository
    # :user - A user object or the login of a user
    # :branch - A branch object or the name of a branch. Defaults to master. 
    # 
    # Sample usage:
    #
    #   >> find_all(:user => "fcoury", :repo => "octopi")
    #   => <Latest 30 commits for master branch>
    #  
    #   => find_all(:user => "fcoury", :repo => "octopi", :branch => "lazy") # branch is set to lazy.
    #   => <Latest 30 commits for lazy branch>
    #
    def self.find_all(opts={})
      repo, user, branch = gather_details(opts)
      commits = super user, repo.name, branch
      # Repository is not passed in from the data, set it manually.
      commits.each { |c| c.repository = repo }
      commits
    end
    
    # Finds all commits for the given options:
    #
    # :repo or :repository or :name - A repository object or the name of a repository
    # :user - A user object or the login of a user
    # :branch - A branch object or the name of a branch. Defaults to master. 
    # :sha - The commit ID
    # 
    # Sample usage:
    #
    #   >> find(:user => "fcoury", :repo => "octopi", :sha => "f6609209c3ac0badd004512d318bfaa508ea10ae")
    #   => <Commit f6609209c3ac0badd004512d318bfaa508ea10ae for branch master>
    #
    #   >> find(:user => "fcoury", :repo => "octopi", :branch => "lazy", :sha => "f6609209c3ac0badd004512d318bfaa508ea10ae") # branch is set to lazy.
    #   => <Commit f6609209c3ac0badd004512d318bfaa508ea10ae for branch lazy>
    #
    def self.find(opts={})
      repo, user, branch, sha = gather_details(opts)
      super [user, repo, sha]
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
    
    private
    
    def self.gather_details(opts)
      repo = self.gather_name(opts)
      repo = Repository.find(:user => opts[:user], :name => repo) if !repo.is_a?(Repository)
      user = repo.owner.to_s
      user ||= opts[:user].to_s
      branch = opts[:branch] || "master"
      self.validate_args(user => :user, repo.name => :repo)
      [repo, user, branch, opts[:sha]]
    end
  end
end
