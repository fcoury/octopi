module Octopi
  class Gist
    class Comment < Octopi::Base
      attr_accessor :gist

      private

      def self.singular_url(id)
        "/gists/comments/#{id}"
      end
    end
  end
end