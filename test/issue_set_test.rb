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
    
    should "not be able to find an issue that doesn't exist" do
      exception = assert_raise Octopi::NotFound do
        @repo.issues.find("not-a-number")
      end
      
      assert_equal "The Issue you were looking for could not be found, or is private.", exception.message
    end
    
    should "be able to look for an issue" do
      results = @repo.issues.search(:keyword => "test")
      assert_not_nil results
      assert_equal 1, results.size
    end
    
  end
end
