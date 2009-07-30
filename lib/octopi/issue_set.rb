require File.join(File.dirname(__FILE__), "issue")
class IssueSet < Array
  attr_accessor :user, :repository
  def find(number)
    Octopi::Issue.find(:user => self.user, :repository => self.repository, :number => number)
  end
  
  def initialize(opts={})
    @user = opts[:user]
    @repository = opts[:repository]
    Octopi::Issue.find_all(:user => opts[:user], :repository => opts[:repository])
  end
end