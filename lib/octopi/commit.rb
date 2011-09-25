module Octopi
  class Commit < Base
    def message
      commit["message"]
    end
  end
end