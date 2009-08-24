# IF TEST FAILS PLEASE SEE TEST_HELPER FOR REASON
require File.join(File.dirname(__FILE__), 'test_helper')

class CommitTest < Test::Unit::TestCase
  include Octopi
  
  def setup
    @user = User.find("radar")
  end

  
  context Commit do
    should "return a commit for a private repository when authed" do
      authenticated do
        repository = @user.repository(:name => "select-copiers")
        assert_not_nil repository.commits
      end
    end
  end
end
