module Octopi
  class Repo < Base
    def owner
      User.new(attributes[:owner])
    end

    def self.by_user(user)
      collection("/users/#{user}/repos")
    end

    def self.by_organization(organization)
      collection("/orgs/#{organization}/repos")
    end

    private

    def self.plural_url
      "/repos"
    end
  end
end