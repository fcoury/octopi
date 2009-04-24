module Octopi
  class LazyRepository < Lazy
    
    def initialize(*arg)
      @arg = *arg
      if Octopi::Repository === @arg
        @name = @arg.name
        @owner = @arg.owner
        super @name, @owner
      else
        @user = arg.first
        @name = arg.last  
        super @user, @name
      end  
    end

    def init_worker
      if Repository === @arg
        @worker ||= @arg
      else 
        @worker ||= Repository.find(@user, @name)
      end  
    end
  
    def self.search(query)
      self.find_all(query).map{|repo| LazyRepository.new repo}
    end

  end    
end
