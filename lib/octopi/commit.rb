module Octopi
  class Commit < Base
    include Resource
    find_path "/commits/list/:query"
    resource_path "/commits/show/:id"
    
    attr_accessor :repository
    
    def self.find_all(user, name, branch = "master", repo = nil)
      repository = repo if repo.is_a? Repository
      user = user.login if user.is_a? User
      repo = repo.name  if repo.is_a? Repository
      name = repo.name  if name.is_a? Repository
      commits = super [user, name, branch]
      commits.each { |c| c.repository = repository } if repository
      commits
    end
    
    def self.find(*args)
      if args.last.is_a?(Commit)
        commit = args.pop
        super "#{commit.repo_identifier}"
      else
        user, name, sha = *args
        user = user.login if user.is_a? User
        name = repo.name  if name.is_a? Repository
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
      
      puts parts.join('/')
      parts.join('/')
    end
  end
end