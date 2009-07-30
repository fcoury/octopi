module Octopi
  class Branch < Base
    attr_accessor :name, :sha
    include Resource
    set_resource_name "branch", "branches"

    resource_path "/repos/show/:id"
    
    def initialize(parts=[])
      self.name = parts.first
      self.sha = parts.last
    end
    
    def to_s
      name
    end
    
    def self.all(user, repo)
      user = user.to_s
      repo = repo.to_s
      self.validate_args(user => :user, repo => :repo)
      BranchSet.new(find_plural([user,repo,'branches'], :resource)) do |i|
        { :name => i.first, :hash => i.last }
      end
    end
  end
end
