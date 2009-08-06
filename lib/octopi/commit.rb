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
    def self.find_all(options={})
      ensure_hash(options)
      user, repo, branch = gather_details(options)
      commits = if options[:path]
        super user, repo.name, branch, options[:path]
      else
        super user, repo.name, branch
      end
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
    def self.find(options={})
      ensure_hash(options)
      user, repo, branch, sha = gather_details(options)
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
  end
end
