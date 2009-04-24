module Octopi
  class LazyUser < Lazy
    
    def initialize(username)
      @username = username
      super
    end

    def init_worker  
      @worker ||= User.find(@username)
    end

  end    
end
