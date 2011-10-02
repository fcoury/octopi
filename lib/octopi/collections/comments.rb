module Octopi
  module Collections
    class Comments < DelegateClass(Array)
      def initialize(repo, collection)
        super(collection)
        each { |comment| comment.repo = repo }
      end
      
      def create(attributes)
        response = Octopi.post("#{first.repo.url}/comments", :body => attributes.to_json)
        parsed_response = Octopi::Base.parse(response)
        if response.code.to_i == 422
          raise Octopi::InvalidResource, parsed_response["errors"]
        else
          Octopi::Comment.new(parsed_response.merge(:repo => first.repo))
        end
      end

      def find(id)
        Octopi::Comment.new(Octopi.get("#{first.repo.url}/comments/#{id}").merge(:repo => first.repo))
      end
    end
  end
end