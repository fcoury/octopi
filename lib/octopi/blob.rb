require File.join(File.dirname(__FILE__), "resource")
module Octopi
  class Blob < Base
    attr_accessor :text
    include Resource
    set_resource_name "blob"

    resource_path "/blob/show/:id"

    def self.find(user, repo, sha, path=nil)
      user = user.login if user.is_a? User
      repo = repo.name if repo.is_a? Repository
      self.validate_args(sha => :sha, user => :user, path => :file)
      if path
        super [user,repo,sha,path]
      else
        blob = Api.api.get_raw(path_for(:resource), 
              {:id => [user,repo,sha].join('/')})
        new({:text => blob})
      end  
    end  
  end
end
