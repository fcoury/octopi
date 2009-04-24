module Octopi
  class LazyUser
    
    def initialize(username)
      @username = username
      @worker = nil
    end

    def method_missing(method,*args)  
      @worker ||= User.find(@username)
      @worker.send(method,args)
    end

  end    
end
