require File.join(File.dirname(__FILE__), "resource")
module Octopi
  class Blob < Base
    attr_accessor :text, :data, :name, :sha, :size, :mode, :mime_type
    include Resource
    set_resource_name "blob"

    resource_path "/blob/show/:id"

    def self.find(options={})
      ensure_hash(options)
      user, repo = gather_details(options)
      sha = options[:sha]
      path = options[:path]
      
      self.validate_args(sha => :sha, user => :user)
      
      if path
        super [user, repo, sha, path]
      else
        Api.api.get_raw(path_for(:resource), {:id => [user, repo, sha].join('/')})
      end  
    end  
  end
end
