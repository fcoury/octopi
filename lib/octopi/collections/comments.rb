module Octopi
  module Collections
    class Comments < DelegateClass(Array)
      def initialize(repo, collection)
        super(collection)
        each { |comment| comment.repo = repo }
      end
    end
  end
end