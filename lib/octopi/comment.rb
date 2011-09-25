module Octopi
  class Comment < Base
    def user
      User.new(attributes[:user])
    end
  end
end