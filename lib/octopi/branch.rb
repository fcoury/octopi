module Octopi
  class Branch < Base
    include Resource
    set_resource_name "branch", "branches"

    resource_path "/repos/show/:id"
    
    def self.find(user, repo)
      user = user.to_s
      repo = repo.to_s
      self.validate_args(user => :user, repo => :repo)
      find_plural([user,repo,'branches'], :resource, @api){
        |i| {:name => i.first, :hash => i.last }
      }
    end
  end
end
