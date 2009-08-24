require File.join(File.dirname(__FILE__), 'test_helper')

class AuthenticatedTest < Test::Unit::TestCase
  include Octopi
  def setup
    fake_everything
  end
  
  context "Authenticating" do
    should "be possible with username and password" do
      authenticated_with(:login => "fcoury", :password => "yruocf") do
        assert_equal "8f700e0d7747826f3e56ee13651414bd", Api.api.token
        assert_not_nil User.find("fcoury")
      end
    end
        
     should "be possible with username and token" do
       auth do
         assert_not_nil User.find("fcoury")
       end
     end
     
     should "be possible using the .gitconfig" do
       authenticated do
         assert_not_nil User.find("fcoury")
       end
     end
     # 
     # should "be denied access when specifying an invalid token and login combination" do
     #   FakeWeb.clean_registry
     #   FakeWeb.register_uri(:get, "http://github.com/api/v2/yaml/user/show/fcoury", :status => ["404", "Not Found"])
     #   assert_raise InvalidLogin do
     #     authenticated_with :login => "fcoury", :token => "ba7bf2d7f0ebc073d3874dda887b18ae" do
     #       # Just blank will do us fine.
     #     end
     #   end 
     # end
  end
end
