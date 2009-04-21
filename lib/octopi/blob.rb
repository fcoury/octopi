module Octopi
  class Blob < Base
    include Resource
    set_resource_name "blob"

    resource_path "/blob/show/:id"

    def self.find(user, repo, sha, path=nil)
      user = user.login if user.is_a? User
      repo = repo.name if repo.is_a? Repository
      self.class.validate_args(sha => :sha, user => :user, path => :file)
      if path
        super [user,repo,sha,path]
      else
        blob = ANONYMOUS_API.get_raw(path_for(:resource), 
              {:id => [user,repo,sha].join('/')})
        new(ANONYMOUS_API, {:text => blob})
      end  
    end  
  end
end
