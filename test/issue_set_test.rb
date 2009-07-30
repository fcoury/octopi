require File.join(File.dirname(__FILE__), 'test_helper')

class IssueSetTest < Test::Unit::TestCase
  include Octopi
  
  def setup
    fake_everything
    @user = User.find("fcoury")
    @repo = @user.repository("octopi")
  end

  
  context IssueSet do
    should "be able to find a specific issue" do
      assert_not_nil @repo.issues.find(28)
    end
    
  end
end
