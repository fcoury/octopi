module Octopi
  class FileObject < Base
    include Resource
    set_resource_name "tree"

    resource_path "/tree/show/:id"

    def self.find(user, repo, sha)
      user = user.login if user.is_a? User
      repo = repo.name if repo.is_a? Repository
      self.validate_args(sha => :sha, user => :user, repo => :repo)
      super [user,repo,sha] 
    end  
  end
end
