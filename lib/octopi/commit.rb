module Octopi
  class Commit < Base
    include Resource
    find_path "/commits/list/:query"
    resource_path "/commits/show/:id"
    
    attr_accessor :repository
    
    # Finds all commits for a given Repository's branch
    #
    # You can provide the user and repo parameters as
    # String or as User and Repository objects. When repo
    # is provided as a Repository object, user is superfluous.
    # 
    # If no branch is given, "master" is assumed.
    #
    # Sample usage:
    #
    #   find_all(repo, :branch => "develop") # repo must be an object
    #   find_all("octopi", :user => "fcoury") # user must be provided
    #   find_all(:user => "fcoury", :repo => "octopi") # branch defaults to master
    #
    def self.find_all(*args)
      repo = args.first
      user ||= repo.owner if repo.is_a? Repository
      user, repo_name, opts = extract_user_repository(*args)
      self.validate_args(user => :user, repo_name => :repo)
      branch = opts[:branch] || "master"
      
      commits = super user, repo_name, branch
      commits.each { |c| c.repository = repo } if repo.is_a? Repository
      commits
    end
    
    # TODO: Make find use hashes like find_all
    def self.find(*args)
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
