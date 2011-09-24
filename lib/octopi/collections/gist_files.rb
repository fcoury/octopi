module Octopi
  module Collections
    class GistFiles < Array
      def initialize(collection)
        super()
        collection.map do |filename, attributes| 
          self << Octopi::Gist::GistFile.new(attributes)
        end
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