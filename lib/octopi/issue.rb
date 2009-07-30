module Octopi
  class Issue < Base
    include Resource
    STATES = %w{open closed}

    find_path "/issues/list/:query"
    resource_path "/issues/show/:id"
    
    attr_accessor :repository, :user, :updated_at, :votes, :number, :title, :body, :closed_at, :labels, :state, :created_at
    
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
    def self.find_all(opts={})
      user, repo = gather_details(opts)
      state = (opts[:state] || "open").downcase
      validate_args(user => :user, repo.name => :repo, state => :state)

      issues = super user, repo.name, state
      issues.each { |i| i.repository = repo } if repo.is_a? Repository
      issues
    end
  
    # TODO: Make find use hashes like find_all
    def self.find(opts={})
      user, repo = gather_details(opts)
      
      validate_args(user => :user, repo => :repo)
      super user, repo, opts[:number]
    end
    
    def self.open(opts={})
      user, repo = gather_details(opts)
      data = Api.api.post("/issues/open/#{user}/#{repo.name}", opts[:params])
      issue = new(data['issue'])
      issue.repository = repo
      issue
    end
    
    # Re-opens an issue.
    def reopen!
      data = @api.post(command_path("reopen"))
      self.state = 'open'
      self
    end
    
    def close!
      data = @api.post(command_path("close"))
      self.state = 'closed'
      self
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
