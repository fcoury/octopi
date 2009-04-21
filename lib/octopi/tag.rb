module Octopi
  class Tag < Base
    include Resource
    set_resource_name "tag"

    resource_path "/repos/show/:id"
    
    def self.find(user, repo)
      user = user.login if user.is_a? User
      repo = repo.name if repo.is_a? Repository
      self.validate_args(user => :user, repo => :repo)
      find_plural([user,repo,'tags'], :resource){
        |i| {:name => i.first, :hash => i.last }
      }
    end
  end
end
