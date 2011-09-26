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
      self.class.collection("#{url}/branches", Octopi::Branch)
    end
    
    def commits(params={})
      params[:sha] ||= params.delete(:branch) if params[:branch]
      Octopi::Collections::Commits.new(self, self.class.collection("#{url}/commits", Octopi::Commit, params))
    end
    
    def comments
      Octopi::Collections::Comments.new(self, self.class.collection("#{url}/comments", Octopi::Comment))
    end
    
    def collaborators
      Octopi::Collections::Collaborators.new(self.class.collection("#{url}/collaborators", Octopi::User))
    end
    
    def url
      Octopi.base_uri + "/repos/#{user.login}/#{self.name}"
    end

    private

    def self.not_found_error
      "The #{self} you were looking for could not be found or it could be private."
    end
  end
end