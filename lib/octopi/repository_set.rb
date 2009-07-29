require File.join(File.dirname(__FILE__), "repository")
class RepositorySet < Array
  attr_accessor :user, :api
  def find(name)
    # Using just Repository doesn't work
    # TODO: figure out why
    Octopi::Repository.find(self.user, name)
  end
end