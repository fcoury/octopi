require File.join(File.dirname(__FILE__), 'test_helper')

class AuthenticatedTest < Test::Unit::TestCase
  include Octopi
  def setup
    fake_everything
  end
  
  context "Authenticating" do
    should "be possible with username and password" do
      authenticated_with(:user => "fcoury", :password => "yruocf") do
        assert_equal "6417354635233fbddf66de798c030f9f", Api.api.token
        assert_not_nil User.find("fcoury")
      end
    end
  end
  
  
end
