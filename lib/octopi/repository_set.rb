require File.join(File.dirname(__FILE__), "repository")
class Octopi::RepositorySet < Array
  include Octopi
  attr_accessor :user
  
  def find(name)
    Octopi::Repository.find(:user => self.user, :repository => name)
  end
end