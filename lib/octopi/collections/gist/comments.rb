module Octopi
  module Collections
    module Gist
      class Comments < DelegateClass(Array)
        def initialize(comments)
          super(comments)
        end

        def create!(attributes)
          Octopi.requires_authentication! do
            comment = gist.class.post("/gists/#{gist.id}/comments", :body => attributes.to_json)
            comment = Octopi::Gist::Comment.new(comment)
            gist.reload
            return comment
          end
        end
      
        private
      
        def gist
          self.first.gist
        end
      end
    end
  end
end