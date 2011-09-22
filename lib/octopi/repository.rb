module Octopi
  class Repository < Base
    def owner
      User.new(attributes["owner"])
    end

    def self.by_user(user)
      collection("/users/#{user}/repos")
    end

    def self.by_organization(organization)
      collection("/orgs/#{organization}/repos")
    end
  end
  # Allow for access as Repo
  Repo = Repository
end