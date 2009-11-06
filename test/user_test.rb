require File.join(File.dirname(__FILE__), 'test_helper')

class UserTest < Test::Unit::TestCase
  include Octopi
  
  def setup
    fake_everything
    @user = User.find("fcoury")
  end
  
  should "be able to find a user" do
    assert_not_nil User.find("fcoury")
  end
    
  should "not be able to find a user that doesn't exist" do
    exception = assert_raise NotFound do 
      User.find("i-am-most-probably-a-user-that-does-not-exist")
    end
    
    assert_equal "The User you were looking for could not be found, or is private.", exception.message
  end
  
  should "be able to look for a user, using find_all" do
    users = User.find_all("radar")
    assert_not_nil users
  end
  
  should "be able to search for a user" do
    users = User.search("radar")
    assert_not_nil users
  end
  
  context "authenticated" do
    should "return all user information" do
      authenticated do
        user = Api.api.user
        assert_not_nil user
        fields = [:company, :name, :following_count, :blog, :public_repo_count, 
                  :public_gist_count, :id, :login, :followers_count, :created_at,
                  :email, :location, :disk_usage, :private_gist_count, :plan, 
                  :owned_private_repo_count, :total_private_repo_count]
        fields.each do |f|
          assert_not_nil user.send(f)
        end
        
        plan_fields = [:name, :collaborators, :space, :private_repos]
        plan_fields.each do |f|
          assert_not_nil user.plan.send(f)
        end
      end
    end
    
    context "return a list of followers" do
    
      should "in string format" do
        users = @user.followers
        assert_not_nil users
        assert users.first.is_a?(String)
      end
    
      should "in object format" do
        users = @user.followers!
        assert_not_nil users
        assert users.first.is_a?(User)
      end
    end
    
    context "return a list of people who they are following" do
      should "in string format" do
        users = @user.following
        assert_not_nil users
        assert users.first.is_a?(String)
      end
    
      should "in object format" do
        users = @user.following!
        assert_not_nil users
        assert users.first.is_a?(User)
      end
    end
    
    context "return a list of watched repositories" do
       should "in an array" do
         @user = User.find("radar")
         repos = @user.watching
         assert_not_nil repos
         assert repos.first.is_a?(Repository)
       end
    end
    
  end
end
