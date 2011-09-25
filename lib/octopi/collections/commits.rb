module Octopi
  module Collections
    class Commits < DelegateClass(Array)
      def initialize(repo, collection)
        super(collection)
        each do |commit|
          commit.repo = repo
        end
      end

      def find(sha)
        Octopi::Commit.new(Octopi.get("#{first.repo.path}/commits/#{sha}").merge(:repo => first.repo))
      end
    end
  end
end