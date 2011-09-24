module Octopi
  class Gist < Base
    autoload :Comment, "octopi/gist/comment"
    autoload :GistFile, "octopi/gist/gist_file"
    autoload :History, "octopi/gist/history"
    
    def self.for_user(user)
      collection("/users/#{user}/gists")
    end
    
    # Will retreive all gists for a user if authenticated.
    # Otherwise, all gists, ordered in reverse order by creation time
    def self.mine
      all
    end
    
    def self.starred
      Octopi.requires_authentication! do
        collection("/gists/starred")
      end
    end

    def initialize(attributes)
      # Clear files and history on initialization, in case we are reloading this object
      # Consider it the same as clearing the cache.
      @files = nil
      @history = nil
      super
      @attributes[:public] = true unless @attributes[:public] == false
      # Link files, history and comments to this gist.
      things = [files, history]
      # Save an API call by not looking for comments if there are none.
      # Also, when a Gist is created there are no comments sent back (duh)
      # Therefore we need to convert the attribute to an integer,
      # as it may be nil when returned.
      things << [comments] if @attributes[:comments].to_i > 0
      things.flatten.each do |thing|
        thing.gist = self
      end
    end
    
    def update_attributes(attributes={})
      url = self.class.singular_url(@attributes[:id])
      self.class.new(self.class.post(url, :body => attributes.to_json))
    end
    
    def destroy
      self.class.delete("/gists/#{self.id}")
    end
    
    alias_method :delete, :destroy
    
    # Action methods

    def star!
      Octopi.requires_authentication! do
        self.class.put("/gists/#{id}/star")
      end
    end
    
    def unstar!
      Octopi.requires_authentication! do
        self.class.delete("/gists/#{id}/star")
      end
    end
    
    def starred?
      Octopi.requires_authentication! do
        self.class.get("/gists/#{id}/star")
      end
    end
    
    def fork!
      Octopi.requires_authentication! do
        self.class.new(self.class.post("/gists/#{id}/fork"))
      end
    end
    
    def add_file!(filename, content)
      Octopi.requires_authentication! do
        self.class.post("/gists/#{id}", :body => { "files" => { filename => content }}.to_json)
        self.reload
      end
    end

    # Association methods

    def user
      if @attributes[:user]
        @user ||= User.new(@attributes[:user])
      end
    end
    
    alias_method :owner, :user

    def history
      @history ||= [*@attributes[:history]].map do |history|
        Octopi::Gist::History.new(history)
      end
    end

    def files
      @files ||= [*@attributes[:files]].map do |filename, attributes| 
        Octopi::Gist::GistFile.new(attributes)
      end
    end

    def comments
      @comments ||= self.class.collection("/gists/#{self.id}/comments", Gist::Comment)
    end
  end
end
