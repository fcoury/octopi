module Octopi
  class Comment < Base
    attr_accessor :repo

    def user
      User.new(attributes[:user])
    end
  end
end