require File.join(File.dirname(__FILE__), 'test_helper')

class AuthenticatedTest < Test::Unit::TestCase
  include Octopi
  
  def setup
    fake_everything
    @user = User.find("fcoury")
  end

  context "following" do  
  
    should "not be able to follow anyone if not authenticated" do
      exception = assert_raise AuthenticationRequired do
        Api.me.follow!("rails")
      end
    end
    
    should "be able to follow a user" do
      auth do
        assert_not_nil Api.me.follow!("rails")
      end
    end
  end
  
  context "unfollowing" do  
  
    should "not be able to follow anyone if not authenticated" do
      exception = assert_raise AuthenticationRequired do
        Api.me.unfollow!("rails")
      end
    end
    
    should "be able to follow a user" do
      auth do
        assert_not_nil Api.me.unfollow!("rails")
      end
    end
  end
  
  context "keys" do
    should "not be able to see keys if not authenticated" do
      exception = assert_raise AuthenticationRequired do
        Api.me.keys
      end
   
      assert_equal "To view keys, you must be authenticated", exception.message
    end
   
    should "have some keys" do
      auth do
        keys = Api.me.keys
        assert keys.is_a?(KeySet)
        assert_equal 2, keys.size
      end
    end
  end
end