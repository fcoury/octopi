module Octopi
  class Commit < Base
    attr_accessor :repo

    def initialize(attributes)
      super
      self.repo = attributes[:repo]
    end

    def message
      commit["message"]
    end
    
    def comments
      Octopi::Collections::Comments.new(self.class.collection("#{path}/comments", Octopi::Comment))      
    end
  end
end