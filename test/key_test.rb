require File.join(File.dirname(__FILE__), 'test_helper')

class KeyTest < Test::Unit::TestCase
  include Octopi
  
  def setup
    fake_everything
    @user = User.find("fcoury")
    auth do
      @key = Api.me.keys.first
    end
  end
  
  context Key do
    
    should "be able to add a key" do
      auth do
        Key.add(:title => "other-computer", :key => "AAAAB3NzaC1yc2EAAAABIwAAAQEA0dyfPrSHHSVD0u3JQlJfLyUrEVeNDW+9imbMHwiuT/IStf8SOroRjWT+/S5cL9m6qmKQBIU4v3LUnMKLTHfiWlqICnTDVRHuSayrHGp193I9kTSGBdM7wFZ2E8hDv5OqXHvAKGmOJvl5RqK0d42mhoK/x3bLRMQXHxwSDmYIFLy9rXLMvbVbdFJbbcqXP6QjnP4fAeebvTnUs6bVzInL9nh8Tqb3qjB5qji2i0MiCz3IouuZonOlef/VEac3Zpm6NcI5rVthPsMY55G8BMu4rVEStbIUlAJPoSBzqOgEKEXQbmWLh3CZnOoqQlLwIIvrKlwnXx26M1b+oOFm8s712Q==")
      end
    end
    
    should "be able to remove a key" do
      auth do
        assert_equal 2, Api.me.keys.size
        @key.remove
        # Just trust me on this one
        FakeWeb.register_uri(:get, "https://#{yaml_api}/user/keys" + auth_query, :response => stub_file(File.join("users", "key-removed")))
        assert_equal 1, Api.me.keys.size
      end
    end
      
      
    
  end
end
