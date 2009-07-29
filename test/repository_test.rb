require File.join(File.dirname(__FILE__), 'test_helper')

class RepositoryTest < Test::Unit::TestCase
  include Octopi
  
  def setup
    fake_everything
    @user = User.find("fcoury")
    @private_repos = authenticated_with("fcoury", "8f700e0d7747826f3e56ee13651414bd") do
      Repository.find_by_user("fcoury")
    end
    @repository = Repository.find(@user, "octopi")
  end

  
  context Issue do
    should "return a repository for a user" do
      assert_not_nil @user.repository("octopi")
    end
    
    should "return a repository for a login" do
      assert_not_nil Repository.find("fcoury", "octopi")
    end
    
    should "be able to look up the repository based on the user and name" do
      assert_not_nil Repository.find(@user, "octopi")
    end
    
    should "be able to look up on a repository object" do
      assert_not_nil Repository.find(@repository)
    end
    
    should "return repositories" do
      assert_equal 43, Repository.find_by_user("fcoury").size
    end
    
    should "return more repositories if authed" do
      assert_equal 44, @private_repos.size
    end
  end
end
