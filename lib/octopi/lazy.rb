module Octopi
  class Lazy
    
    %w{user}.each {|f| require File.dirname(__FILE__) + "/lazy#{f}"}   
    
    def initialize(*args)
      @worker = nil
      @args = args
    end
    
    def self.method_missing(method,*args)
      worker_class.send(method, *args)
    end

    def method_missing(method,*args)  
      if self.class.worker_class.respond_to? method
        @args.concat args
        self.class.worker_class.send(method,*@args.compact)
      else 
        self.init_worker
        @worker.send(method,*args)
      end 
    end
    
    def self.worker_class
      Kernel.const_get self.to_s.sub(/^Octopi::Lazy/,'')
    end  

  end    
end
