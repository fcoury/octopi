module Octopi
  class Repository < Base
    include Resource
    attr_accessor :description, :url, :forks, :name, :homepage, :watchers, :private, :owner, :fork, :open_issues
    set_resource_name "repository", "repositories"

    create_path "/repos/create"
    find_path "/repos/search/:query"
    resource_path "/repos/show/:id"
    delete_path "/repos/delete/:id"
    
    attr_accessor :private
    
    # Returns all branches for the Repository
    #
    # Example:
    #   repo = Repository.find("fcoury", "octopi")
    #   repo.branches.each { |r| puts r.name }
    #
    def branches
      Branch.all(self.owner, self.name)
    end  

    # Returns all tags for the Repository
    #
    # Example:
    #   repo = Repository.find("fcoury", "octopi")
    #   repo.tags.each { |t| puts t.name }
    #
    def tags
      Tag.find(self.owner, self.name)
    end  
    
    
    # Returns all the comments for a Repository
    def comments
      # We have to specify xmlns as a prefix as the document is namespaced.
      # Be wary!
      path = "http#{'s' if private}://github.com/#{owner}/#{name}/comments.atom"
      xml = Nokogiri::XML(Net::HTTP.get(URI.parse(path)))
      entries = xml.xpath("//xmlns:entry")
      comments = []
      for entry in entries
        content = entry.xpath("xmlns:content").text.gsub("&lt;", "<").gsub("&gt;", ">")
        comments << Comment.new(
          :id => entry.xpath("xmlns:id"),
          :published => Time.parse(entry.xpath("xmlns:published").text),
          :updated => Time.parse(entry.xpath("xmlns:updated").text),
          :link => entry.xpath("xmlns:link/@href").text,
          :title => entry.xpath("xmlns:title").text,
          :content => content,
          :author => entry.xpath("xmlns:author/xmlns:name").text,
          :repository => self
        )
      end
      comments
    end
    
    def clone_url
      if private? || api.login == self.owner
        "git@github.com:#{self.owner}/#{self.name}.git"  
      else
        "git://github.com/#{self.owner}/#{self.name}.git"  
      end
    end
    
    def self.find(options={})
      self.validate_hash(options)
      # Lots of people call the same thing differently.
      repo = options[:repo] || options[:repository] || options[:name]
      user = options[:user].to_s
    
      return find_plural(user, :resource) if repo.nil?
      
      self.validate_args(user => :user, repo => :repo)
      super user, repo
    end

    def self.find_all(*args)
      # FIXME: This should be URI escaped, but have to check how the API
      # handles escaped characters first.
      super args.join(" ").gsub(/ /,'+')
    end
    
    def self.open_issue(args)
      Issue.open(args[:user], args[:repo], args)
    end
    
    def open_issue(args)
      Issue.open(self.owner, self, args)
    end
    
    def commits(branch = "master")
      Commit.find_all(self, {:branch => branch})
    end
    
    def issues(state = "open")
      # TODO: uh oh, duplication. This is bad.
      IssueSet.new(Issue.find_all(:repo => self, :user => self.owner, :state => state ), :repository => self, :user => self.owner)
    end
   
    def all_issues
      Issue::STATES.map{|state| self.issues(state)}.flatten
    end

    def issue(number)
      Issue.find(self.owner, self, number)
    end

    def collaborators
      property('collaborators', [self.owner,self.name].join('/')).values
    end  
    
    def self.create(owner, name, opts = {})
      api = owner.is_a?(User) ? owner.api : ANONYMOUS_API
      raise APIError, "To create a repository you must be authenticated." if api.read_only?
      self.validate_args(name => :repo)
      api.post(path_for(:create), opts.merge(:name => name))
      self.find(owner, name, api)
    end
    
    def delete
      token = @api.post(self.class.path_for(:delete), :id => self.name)['delete_token']
      @api.post(self.class.path_for(:delete), :id => self.name, :delete_token => token) unless token.nil?
    end
    
    def to_s
      name
    end

  end
end
