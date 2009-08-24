require File.join(File.dirname(__FILE__), 'test_helper')

class IssueTest < Test::Unit::TestCase
  include Octopi
  
  def setup
    fake_everything
    @user = User.find("fcoury")
    @repo = @user.repository("octopi")
    @issue = Issue.find(:user => @user, :repo => @repo, :number => 28)
    @closed = Issue.find(:user => @user, :repo => @repo, :number => 27)
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
      
      should "not work, if issue doesn't exist" do
        exception = assert_raise NotFound do
          Issue.find(:user => @user, :repo => @repo, :number => "not-a-number")
        end
        
        assert_equal "The Issue you were looking for could not be found, or is private.", exception.message
      end
      
      should "be able to look for an issue" do
        results = Issue.search(:user => @user, :repo => @repo, :keyword => "test")
        assert_not_nil results
        assert_equal 1, results.size
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
    
      should "closing an issue" do
        assert_equal "open", @issue.state
        @issue.close!
        assert_equal "closed", @issue.state
      end
    
      should "editing an issue" do
        @issue.title = 'Testing'
        @issue.save
        assert_equal "Testing", @issue.title
      end
    
      should "adding a label" do
        assert @issue.labels.empty?
        @issue.add_label("one-point-oh")
        assert !@issue.labels.empty?
      end
    
      should "adding multiple labels" do
        assert @issue.labels.empty?
        @issue.add_label("one-point-oh", "maybe-two-point-oh")
        assert !@issue.labels.empty?
        assert 2, @issue.labels.size
      end
    
      should "removing a label" do
        assert @issue.labels.empty?
        @issue.add_label("one-point-oh")
        assert !@issue.labels.empty?
        @issue.remove_label("one-point-oh")
        assert @issue.labels.empty?
      end
    
      should "removing multiple labels" do
        assert @issue.labels.empty?
        @issue.add_label("one-point-oh", "maybe-two-point-oh")
        assert !@issue.labels.empty?
        assert_equal 2, @issue.labels.size
        @issue.remove_label("one-point-oh", "maybe-two-point-oh")
        assert_equal 0, @issue.labels.size
      
      end
    
      should "be able to comment" do
        comment = @issue.comment("Yes, it is broken.")
        assert comment.is_a?(IssueComment)
      end
    end
  end
end
