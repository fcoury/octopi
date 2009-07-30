module Octopi
  class Issue < Base
    include Resource
    STATES = %w{open closed}

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
      state = opts[:state] || "open"
      state.downcase! if state
      validate_args(user => :user, repo_name => :repo, state => :state)

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
      user, repo_name = extract_names(user, repo)
      data = api.post("/issues/open/#{user}/#{repo_name}", params)
      issue = new(api, data['issue'])
      issue.repository = repo if repo.is_a? Repository
      issue
    end
    
    def reopen(*args)
      data = @api.post(command_path("reopen"))
    end
    
    def close(*args)
      data = @api.post(command_path("close"))
    end
    
    def save
      data = @api.post(command_path("edit"), { :title => self.title, :body => self.body })
    end
    
    %w(add remove).each do |oper|
      define_method("#{oper}_label") do |*labels|
        labels.each do |label|
          @api.post("#{prefix("label/#{oper}")}/#{label}/#{number}")
        end
      end
    end

    def comment(comment)
      @api.post(command_path("comment"), { :comment => comment })
    end
    
    private
    def prefix(command)
      "/issues/#{command}/#{repository.owner}/#{repository.name}"
    end
    
    def command_path(command)
      "#{prefix(command)}/#{number}"
    end
  end
end
