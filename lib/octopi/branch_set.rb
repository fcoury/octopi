require File.join(File.dirname(__FILE__), "branch")
class BranchSet < Array
  include Octopi
  attr_accessor :user, :repository
  # Takes a name, returns a branch if it exists
  def find(name)
    branch = detect { |b| b.name == name }
    raise NotFound, Branch if branch.nil?
    branch
  end
end