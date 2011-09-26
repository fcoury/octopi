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
    end
  end
end