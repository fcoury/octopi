require File.join(File.dirname(__FILE__), "repository")
class RepositorySet < Array
  attr_accessor :user, :api
  def find(name)
    Octopi::Repository.find(:user => self.user, :repository => name)
  end
end