module Octopi
  class Gist
    # TODO: I really, really hate the name of this class.
    # It's duplicating the names.
    # Can't name it File though as it clashes with Ruby's.
    class GistFile < Octopi::Base
      attr_accessor :gist
      attr_accessor :content
      
      def delete!
        Octopi.requires_authentication! do
          self.class.post("/gists/#{gist.id}", :body => { "files" => { self.filename => nil }}.to_json)
          # Remove the file from the gist on our side.
          self.gist.files.delete_if { |file| file.filename == self.filename } 
        end
      end
      
      def save
        self.class.post("/gists/#{gist.id}", :body => { "files" => { self.filename => self.content }}.to_json)
      end
      
    end
  end
end