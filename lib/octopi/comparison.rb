module Octopi
  class Comparison < Base
    def base_commit
      Commit.new(attributes[:base_commit])
    end
    
    def commits
      attributes[:commits].map do |commit|
        Commit.new(commit)
      end
    end
  end
end