module Octopi
  class Repo < Base
    def self.by_user(user)
      collection("/users/#{user}/repos")
    end

    def self.by_organization(organization)
      collection("/orgs/#{organization}/repos")
    end

    def owner
      User.new(attributes[:owner])
    end
    
    alias_method :user, :owner

    def organization
      Organization.new(attributes[:organization])
    end
    
    def branches
      self.class.collection("/repos/#{user.login}/#{self.name}/branches", Octopi::Branch)
    end

    private

    def self.not_found_error
      "The #{self} you were looking for could not be found or it could be private."
    end
  end
end