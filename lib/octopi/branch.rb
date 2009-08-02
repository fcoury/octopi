module Octopi
  class Branch < Base
    attr_accessor :name, :sha
    include Resource
    set_resource_name "branch", "branches"

    resource_path "/repos/show/:id"
    
    # Called when we ask for a resource.
    # Arguments are passed in like [<name>, <sha>]
    # TODO: Find out why args are doubly nested
    def initialize(*args)
      args = args.flatten!
      self.name = args.first
      self.sha = args.last
    end
    
    def to_s
      name
    end
    
    def self.all(options={})
      ensure_hash(options)
      user, repo = gather_details(options)
      self.validate_args(user => :user, repo => :repo)
      BranchSet.new(find_plural([user, repo, 'branches'], :resource)) do |i|
        { :name => i.first, :hash => i.last }
      end
    end
  end
end
