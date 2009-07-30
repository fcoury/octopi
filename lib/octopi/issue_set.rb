require File.join(File.dirname(__FILE__), "issue")
class IssueSet < Array
  attr_accessor :user, :repository
  def find(number)
    Octopi::Issue.find(:user => user, :repository => repository, :number => number)
  end

end