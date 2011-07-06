require File.join(File.dirname(__FILE__), "tree")
class Octopi::TreeSet < Array
  include Octopi
  attr_accessor :user, :repository
  
  def initialize(array)
    self.user = array.first.user
    self.repository = array.first.repository
    super(array)
  end
end