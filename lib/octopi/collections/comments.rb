module Octopi
  module Collections
    class Comments < DelegateClass(Array)
      def initialize(repo, collection)
        super(collection)
        each { |comment| comment.repo = repo }
      end
      
      def create(attributes)
        Octopi::Comment.new(Octopi.post("#{first.repo.url}/comments", :body => attributes.to_json).merge(:repo => first.repo))
      end

      def find(id)
        Octopi::Comment.new(Octopi.get("#{first.repo.url}/comments/#{id}").merge(:repo => first.repo))
      end
    end
  end
end