require File.join(File.dirname(__FILE__), 'test_helper')

class KeySetTest < Test::Unit::TestCase
  include Octopi
  
  def setup
    fake_everything
    @user = User.find("fcoury")
  end

  
  context KeySet do
    should "be able to find a key" do
      auth do
        assert_not_nil Api.me.keys.find("macbook")
      end
    end
    
    should "not be able to find a key without a valid title" do
      exception = assert_raise NotFound do
        auth do
          assert_not_nil Api.me.keys.find("windows-box")
        end
      end
      
      assert_equal "The Key you were looking for could not be found, or is private.", exception.message
    end
  end
end
