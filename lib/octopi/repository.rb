module Octopi
  class Repository < Base
    include Resource
    attr_accessor :description, :url, :forks, :name, :homepage, :watchers, 
                  :owner, :private, :fork, :open_issues, :pledgie, :size,
                  # And now for the stuff returned by search results
                  :actions, :score, :language, :followers, :type, :username,
                  :id, :pushed, :created
    set_resource_name "repository", "repositories"

    create_path "/repos/create"
    find_path "/repos/search/:query"
    resource_path "/repos/show/:id"
    delete_path "/repos/delete/:id"
    
    attr_accessor :private
    
    def owner=(owner)
      @owner = User.find(owner)
    end
    
    # Returns all branches for the Repository
    #
    # Example:
    #   repo = Repository.find("fcoury", "octopi")
    #   repo.branches.each { |r| puts r.name }
    #
    def branches
      Branch.all(:user => self.owner, :repo => self)
    end  

    # Returns all tags for the Repository
    #
    # Example:
    #   repo = Repository.find("fcoury", "octopi")
    #   repo.tags.each { |t| puts t.name }
    #
    def tags
      Tag.all(:user => self.owner, :repo => self)
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
      url = private || Api.api.login == self.owner.login ? "git@github.com:" : "git://github.com/"
      url += "#{self.owner}/#{self.name}.git"
    end
    
    def self.find(options={})
      ensure_hash(options)
      # Lots of people call the same thing differently.
      # Can't call gather_details here because this method is used by it internally.
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
    
    class << self 
      alias_method :search, :find_all
    end
    
    def commits(branch = "master")
      Commit.find_all(:user => self.owner, :repo => self, :branch => branch)
    end
    
    def issues(state = "open")
      IssueSet.new(Octopi::Issue.find_all(:user => owner, :repository => self))
    end
   
    def all_issues
      Issue::STATES.map{|state| self.issues(state)}.flatten
    end

    def issue(number)
      Issue.find(:user => self.owner, :repo => self, :number => number)
    end

    def collaborators
      property('collaborators', [self.owner, self.name].join('/')).values.map { |v| User.find(v.join) }
    end  
    
    def self.create(options={})
      raise AuthenticationRequired, "To create a repository you must be authenticated." if Api.api.read_only?
      self.validate_args(options[:name] => :repo)
      new(Api.api.post(path_for(:create), options)["repository"])
    end
    
    def delete!
      raise APIError, "You must be authenticated as the owner of this repository to delete it" if Api.me.login != owner.login
      token = Api.api.post(self.class.path_for(:delete), :id => self.name)['delete_token']
      Api.api.post(self.class.path_for(:delete), :id => self.name, :delete_token => token) unless token.nil?
    end
    
    def to_s
      name
    end

  end
end
