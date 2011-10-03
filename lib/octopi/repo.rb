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
    
    def watchers_count
      attributes[:watchers]
    end
    
    def watchers
      self.class.collection("#{url}/watchers", Octopi::User)
    end
    
    def forks_count
      attributes[:forks]
    end
    
    def forks
      self.class.collection("#{url}/forks", Octopi::Repo)
    end

    def is_collaborator?(user)
      login = user.is_a?(Octopi::User) ? user.login : user
      # 204 request == yes, this person is a collaborator
      self.class.get("#{url}/collaborators/#{login}").response.code.to_i == 204
    end
    
    def languages
      self.class.collection("#{url}/languages", Octopi::Language)
    end
    
    def tags
      self.class.collection("#{url}/tags", Octopi::Tag)
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
