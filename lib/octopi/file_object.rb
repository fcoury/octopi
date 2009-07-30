module Octopi
  class FileObject < Base
    attr_accessor :name, :sha, :mode, :type
    
    include Resource
    set_resource_name "tree"

    resource_path "/tree/show/:id"

    def self.find(opts={})
      user, repo, branch, sha = gather_details(opts)
      self.validate_args(sha => :sha, user => :user, repo => :repo)
      super [user, repo, sha] 
    end  
  end
end
