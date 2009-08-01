module Octopi
  class Tag < Base
    include Resource
    
    attr_accessor :name, :sha
    set_resource_name "tag"

    resource_path "/repos/show/:id"
    
    def initialize(*args)
      args = args.flatten!
      self.name = args.first
      self.sha = args.last
    end
    
    def self.all(options={})
      user, repo = gather_details(options)
      self.validate_args(user => :user, repo => :repo)
      find_plural([user, repo, 'tags'], :resource) { |i| {:name => i.first, :hash => i.last } }
    end
  end
end
