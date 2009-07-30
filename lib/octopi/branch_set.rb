require File.join(File.dirname(__FILE__), "branch")
class BranchSet < Array
  attr_accessor :user, :repository
  def find(name)
    branch = detect { |b| b.name == name }
    raise Octopi::NotFound, self.class
    branch
  end
end