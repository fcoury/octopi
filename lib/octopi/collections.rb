require 'delegate'

module Octopi
  module Collections
    autoload :Commits, "octopi/collections/commits"
    module Gist
      autoload :Comments, "octopi/collections/gist/comments"
      autoload :Files, "octopi/collections/gist/files"
    end
  end
end