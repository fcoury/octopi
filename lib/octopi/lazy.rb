module Octopi
  class Lazy
    
    %w{user}.each {|f| require File.dirname(__FILE__) + "/lazy#{f}"}   
    
    def initialize(*args)
      @worker = nil
      @args = args
    end

    def method_missing(method,*args)  
      self.init_worker
      if @worker.class.respond_to? method
        @args << args
        @worker.class.send(method,*@args)
      else 
        @worker.send(method,*args)
      end 
    end

  end    
end
