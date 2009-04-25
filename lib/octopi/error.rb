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
    def initalize(status=nil)
      $stderr.puts "GitHub returned status #{status.nil? ? '???' : status}. Retrying request."
    end  
  end

end
