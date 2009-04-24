module Octopi
  class Lazy
    
    %w{user}.each {|f| require File.dirname(__FILE__) + "/lazy#{f}"}   
    
    def initialize(*args)
      @worker = nil
    end

    def method_missing(method,*args)  
      self.init_worker
      @worker.send(method,args)
    end

  end    
end
