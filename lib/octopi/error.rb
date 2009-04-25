module Octopi

  class FormatError < StandardError
   def initialize(f)
     $stderr.puts "Got unexpected format (got #{f.first} for #{f.last})"
   end
  end 

  class APIError < StandardError
   def initialize(m)
     $stderr.puts m 
   end
  end

  class RetryableAPIError < RuntimeError
    attr_reader :code
    def initialize(code=nil)
      @code = code.nil? ? '???' : code
      @message = "GitHub returned status #{@code}. Retrying request."
      super @message
    end  
  end
end
