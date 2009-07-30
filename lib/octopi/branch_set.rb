require File.join(File.dirname(__FILE__), "branch")
class BranchSet < Array
  attr_accessor :user, :repository
  # Takes either a name or a branch object
  # Returns a branch object
  def find(name_or_branch)
    return if name_or_branch.is_a?(Octopi::Branch)
    branch = detect { |b| b.name == name_or_branch }
    raise Octopi::NotFound, Octopi::Branch if branch.nil?
    branch
  end
end