module Octopi
  class IssueComment < Base
    include Resource
    attr_accessor :comment, :status
    
  end
end