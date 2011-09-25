module Octopi
  module Collections
    module Gist
      class Files < DelegateClass(Array)
        def initialize(collection)
          collection = collection.map do |filename, attributes| 
            Octopi::Gist::GistFile.new(attributes)
          end
          super(collection)
        end

        def add!(filename, content)
          Octopi.requires_authentication! do
            gist.update({ "files" => { filename => content }}.to_json)
            gist.reload
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