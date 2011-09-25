module Octopi
  module Collections
    class Commits < DelegateClass(Array)
      def find(sha)
        super { |commit| commit.sha =~ /^#{sha}/ }
      end
    end
  end
end