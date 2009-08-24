# IF TEST FAILS PLEASE SEE TEST_HELPER FOR REASON
require File.join(File.dirname(__FILE__), 'test_helper')

class RepositoryTest < Test::Unit::TestCase
  include Octopi
  
  def setup
    @user = User.find("radar")
  end

  
  context Repository do
    should "return a private repository when authed" do
      authenticated do
        assert_not_nil @user.repository(:name => "select-copiers")
      end
    end
  end
end
