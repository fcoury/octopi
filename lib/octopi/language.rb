module Octopi
  class Language < Base
    attr_accessor :name, :line_count
    def initialize(attributes)
      self.name = attributes.first
      self.line_count = attributes.last
    end
  end
end