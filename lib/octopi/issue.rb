module Octopi
  class Issue < Base
    include Resource
    STATES = %w{open closed}

    find_path "/issues/list/:query"
    resource_path "/issues/show/:id"
    
    
    attr_accessor :repository, :user, :updated_at, :votes, :number, :title, :body, :closed_at, :labels, :state, :created_at
    
    def self.search(options={})
      ensure_hash(options)
      options[:state] ||= "open"
      user, repo = gather_details(options)
      Api.api.get("/issues/search/#{user}/#{repo}/#{options[:state]}/#{options[:keyword]}")
    end
    
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
    def self.find_all(options={})
      ensure_hash(options)
      user, repo = gather_details(options)
      state = (options[:state] || "open").downcase
      validate_args(user => :user, repo.name => :repo, state => :state)

      issues = super user, repo.name, state
      issues.each { |i| i.repository = repo }
      issues
    end
  
    # TODO: Make find use hashes like find_all
    def self.find(options={})
      ensure_hash(options)
      # Do not cache issues, as they may change via other means.
      @cache = false
      user, repo = gather_details(options)
      
      validate_args(user => :user, repo => :repo)
      issue = super user, repo, options[:number]
      issue.repository = repo
      issue
    end
    
    def self.open(options={})
      ensure_hash(options)
      user, repo = gather_details(options)
      data = Api.api.post("/issues/open/#{user}/#{repo.name}", options[:params])
      issue = new(data['issue'])
      issue.repository = repo
      issue
    end
    
    # Re-opens an issue.
    def reopen!
      data = Api.api.post(command_path("reopen"))
      self.state = 'open'
      self
    end
    
    def close!
      data = Api.api.post(command_path("close"))
      self.state = 'closed'
      self
    end
    
    def save
      data = Api.api.post(command_path("edit"), { :title => title, :body => body })
      self
    end
    
    %w(add remove).each do |oper|
      define_method("#{oper}_label") do |*labels|
        labels.each do |label|
          Api.api.post("#{prefix("label/#{oper}")}/#{label}/#{number}", { :cache => false })
          if oper == "add"
            self.labels << label
          else
            self.labels -= [label]
          end
        end
      end
    end

    def comment(comment)
      data = Api.api.post(command_path("comment"), { :comment => comment })
      IssueComment.new(data['comment'])
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
