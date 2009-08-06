module Octopi
  class Comment < Base
    attr_accessor :content, :author, :title, :updated, :link, :published, :id, :repository
    include Resource
    set_resource_name "tree"

    resource_path "/tree/show/:id"

    def self.find(options={})
      ensure_hash(options)
      user, repo, branch, sha = gather_details(options)
      self.validate_args(sha => :sha, user => :user, repo => :repo)
      super [user, repo, sha] 
    end 
    
    def commit
      Commit.find(:user => repository.owner, :repo => repository, :sha => /commit\/(.*?)#/.match(link)[1])
    end
  end
end
