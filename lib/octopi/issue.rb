module Octopi
  class Issue < Base
    include Resource
    
    find_path "/issues/list/:query"
    resource_path "/issues/show/:id"
    
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
      validate_args(user => :user, repo_name => :repo)
      state = opts[:state] || "open"
      state.downcase! if state
      
      raise "State should be either 'open' or 'closed'" unless ['open', 'closed'].include? state
      
      issues = super user, repo_name, state
      issues.each { |i| i.repository = repo } if repo.is_a? Repository
      issues
    end
  
    # TODO: Make find use hashes like find_all
    def self.find(*args)
      if args.length < 2
        raise "Issue.find needs user, repository and issue number"
      end
      
      number = args.pop.to_i if args.last.respond_to?(:to_i)
      number = args.pop if args.last.is_a?(Integer)
      
      raise "Issue.find needs issue number as the last argument" unless number
      
      if args.length > 1
        user, repo = *args
      else
        repo = args.pop
        raise "Issue.find needs at least a Repository object and issue number" unless repo.is_a? Repository
        user, repo = repo.owner, repo.name
      end
      
      user, repo = extract_names(user, repo)
      validate_args(user => :user, repo => :repo)
      super user, repo, number
    end
    
    def self.open(user, repo, params, api = ANONYMOUS_API)
      data = api.post("/issues/open/#{user}/#{repo}", params)
      new(api, data)
    end
  end
end
