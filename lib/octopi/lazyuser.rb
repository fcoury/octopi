module Octopi
  class LazyUser < Lazy
   
    attr_reader :username 
    alias :login :username

    def initialize(arg)
      super @username = String === arg ? arg : arg.name
    end

    def init_worker
      if User === @username
        @worker ||= @username
      else 
        @worker ||= User.find(@username)
      end  
    end
  
    def self.search(query)
      self.find_all(query).map{|u| LazyUser.new u}
    end

  end    
end
