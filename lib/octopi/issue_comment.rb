module Octopi
  class IssueComment < Base
    include Resource
    attr_accessor :body, :user
  end
end