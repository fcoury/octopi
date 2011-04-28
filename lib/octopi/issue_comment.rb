module Octopi
  class IssueComment < Base
    include Resource
    attr_accessor :body, :user, :gravatar_id, :created_at, :updated_at, :id
  end
end