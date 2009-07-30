require File.join(File.dirname(__FILE__), "resource")
module Octopi
  class Blob < Base
    attr_accessor :text
    include Resource
    set_resource_name "blob"

    resource_path "/blob/show/:id"

    def self.find(user, repo, sha, path = nil)
      user = user.to_s
      repo = repo.to_s
      self.validate_args(sha => :sha, user => :user)
      if path
        super [user, repo, sha, path]
      else
        blob = Api.api.get_raw(path_for(:resource), 
              {:id => [user, repo, sha].join('/')})
        new(:text => blob)
      end  
    end  
  end
end
