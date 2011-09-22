module Octopi
  class Repository < Base
    attr_accessor :clone_url, :created_at, :description, :fork, :forks,
                  :git_url, :homepage, :html_url, :id, :language,
                  :master_branch, :name, :open_issues, :owner, :private,
                  :pushed_at, :size, :ssh_url, :svn_url, :updated_at, 
                  :url, :watchers
    # Returns repositories for a user
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