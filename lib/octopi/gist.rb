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
      super
      @attributes[:public] = true unless @attributes[:public] == false
    end

    def user
      @user ||= User.new(@attributes["user"]) if @attributes["user"]
    end
    
    alias_method :owner, :user

    def history
      @history ||= @attributes["history"].map do |history|
        Octopi::Gist::History.new(history)
      end
    end

    def files
      @files ||= @attributes["files"].map do |name, attributes| 
        Octopi::Gist::GistFile.new(attributes.merge(:name => name))
      end
    end

    def comments
      @comments ||= @attributes["comments"].map do |comment|
        Octopi::Gist::Comment.new(comment)
      end
    end
  end
end