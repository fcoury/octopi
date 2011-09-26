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
      collection = self.class.collection("#{self.repo.url}/commits/#{self.sha}/comments", Octopi::Comment)
      Octopi::Collections::Comments.new(self.repo, collection)
    end
  end
end