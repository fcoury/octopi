module Octopi
  class Branch < Base
    include Resource
    set_resource_name "branch", "branches"

    resource_path "/repos/show/:id"
    
    def self.find(user, repo, api=ANONYMOUS_API)
      user = user.login if user.is_a? User
      repo = repo.name if repo.is_a? Repository
      self.validate_args(user => :user, repo => :repo)
      api = ANONYMOUS_API if repo.is_a?(Repository) && !repo.private
      find_plural([user,repo,'branches'], :resource, api){
        |i| {:name => i.first, :hash => i.last }
      }
    end
  end
end
