module Octopi
  class Issue < Base
    include Resource
    
    find_path "/issues/list/:query"
    resource_path "/user/show/:id"
    
    attr_accessor :repository
    
    # Finds all issues for a given Repository
    #
    # You can provide the user and repo parameters as
    # String or as User and Repository objects. When repo
    # is provided as a Repository object, user is superfluous.
    # 
    # If no state is given, "open" is assumed.
    #
    # Sample usage:
    #
    #   find_all(repo, :state => "closed") # repo must be an object
    #   find_all("octopi", :user => "fcoury") # user must be provided
    #   find_all(:user => "fcoury", :repo => "octopi") # state defaults to open
    #
    def self.find_all(*args)
      repo = args.first
      user, repo_name, opts = extract_user_repository(*args)
      state = opts[:state] || "open"
      state.downcase! if state
      
      raise "State should be either 'open' or 'closed'" unless ['open', 'closed'].include? state
      
      issues = super user, repo_name, state
      issues.each { |i| i.repository = repo } if repo.is_a? Repository
      issues
    end
  
    # TODO: Make find use hashes like find_all
    def self.find(*args)
      if args.last.is_a?(Issue)
        commit = args.pop
        super "#{issue.number}"
      else
        user, name, number = *args
        user = user.login if user.is_a? User
        name = repo.name  if name.is_a? Repository
        super user, name, number
      end
    end
  end
end