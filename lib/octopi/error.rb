module Octopi

  class FormatError < StandardError
   def initialize(f)
     super("Got unexpected format (got #{f.first} for #{f.last})")
   end
  end
  
  class AuthenticationRequired < StandardError
  end

  class APIError < StandardError
  end
  
  class InvalidLogin < StandardError
  end

  class RetryableAPIError < RuntimeError
    attr_reader :code
    def initialize(code=nil)
      @code = code.nil? ? '???' : code
      @message = "GitHub returned status #{@code}. Retrying request."
      super @message
    end  
  end
  
  class ArgumentMustBeHash < Exception; end
  
  
  class NotFound < Exception
    def initialize(klass)
      super "The #{klass.to_s.split("::").last} you were looking for could not be found, or is private."
    end
  end
end
