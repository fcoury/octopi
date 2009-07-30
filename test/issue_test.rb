require File.join(File.dirname(__FILE__), 'test_helper')

class IssueTest < Test::Unit::TestCase
  include Octopi
  
  def setup
    fake_everything
    @user = User.find("fcoury")
    @repo = @user.repository("octopi")
    @issue = @repo.issues.first
    @closed = @repo.issues.find(27)
  end

  
  context Issue do
    context "finding all the issues" do
      should "using objects" do
        issues = Issue.find_all(:user => @user, :repo => @repo)
        assert_not_nil issues
        assert_equal 21, issues.size
      end
      
      should "using strings" do
        issues = Issue.find_all(:user => "fcoury", :repo => "octopi")
        assert_not_nil issues
        assert_equal 21, issues.size
      end
      
      should "specifying a state" do
        issues = Issue.find_all(:user => @user, :repo => @repo, :state => "closed")
        assert_not_nil issues
        assert_equal 9, issues.size
      end
    end
    
    context "finding a single issue" do
      should "work" do
        issue = Issue.find(:user => @user, :repo => @repo, :number => 28)
        assert_not_nil issue
        assert_not_nil issue.body
      end
    end
    
    context "actions" do
      should "opening an issue" do
        issue = Issue.open(:user => @user, :repo => @repo, :params => { :title => "something's broken", :body => "something broke" })
        assert_not_nil issue
        assert_equal "open", issue.state
      end
      
      should "re-opening an issue" do
        assert_equal "closed", @closed.state
        @closed.reopen!
        assert_equal "open", @closed.state
      end
    end
  end
end
