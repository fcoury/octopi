module Octopi
  module Collections
    class Commits < DelegateClass(Array)
      def initialize(repo, collection)
        super(collection)
        each { |commit| commit.repo = repo }
      end

      def find(sha)
        Octopi::Commit.new(Octopi.get("#{first.repo.url}/commits/#{sha}").merge(:repo => first.repo))
      end
      
      def compare(sha1, sha2)
        Octopi::Comparison.new(Octopi.get("#{first.repo.url}/compare/#{sha1}...#{sha2}"))
      end
    end
  end
end