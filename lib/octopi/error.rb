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

end
