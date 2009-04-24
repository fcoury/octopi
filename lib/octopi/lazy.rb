module Octopi
  class Lazy
    
    %w{user}.each {|f| require File.dirname(__FILE__) + "/lazy#{f}"}   
    
    def initialize(*args)
      @worker = nil
      @args = args
    end
    
    def self.method_missing(method,*args)
      $stderr.puts "Lazy does not handle missing class methods"
      super method, *args
    end

    def method_missing(method,*args)  
      if self.worker_class.respond_to? method
        @args.concat args
        self.worker_class.send(method,@args.first)
      else 
        self.init_worker
        @worker.send(method,*args)
      end 
    end
    
    def worker_class
      Kernel.const_get self.class.to_s.sub(/^Octopi::Lazy/,'')
    end  

  end    
end
