require File.join(File.dirname(__FILE__), "issue")
class IssueSet < Array
  attr_accessor :user, :repository
  def find(number)
    detect { |issue| issue.number == number }
  end
end