require File.join(File.dirname(__FILE__), 'test_helper')

class IssueTest < Test::Unit::TestCase
  include Octopi
  
  def setup
    fake_everything
    @user = User.find("fcoury")
    @repo = @user.repository("octopi")
  end
  
  context IssueComment do
    should "be valid" do
      comment = IssueComment.new({ :comment => "This is a comment", :status => "saved"})
      assert_not_nil comment.comment
      assert_not_nil comment.status
    end
  end
end
