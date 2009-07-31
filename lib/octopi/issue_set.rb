require File.join(File.dirname(__FILE__), "issue")
class Octopi::IssueSet < Array
  include Octopi
  attr_accessor :user, :repository
  def find(number)
    issue = detect { |issue| issue.number == number }
    raise NotFound, Issue if issue.nil?
    issue
  end
end