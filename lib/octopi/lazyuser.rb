module Octopi
  class LazyUser < Lazy
    
    def initialize(arg)
      @username = arg
      super User === arg ? arg.name : @username
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
