require File.join(File.dirname(__FILE__), 'test_helper')

class RepositorySetTest < Test::Unit::TestCase
  include Octopi
  
  def setup
    fake_everything
    @user = User.find("fcoury")
  end

  
  context RepositorySet do
  
    should "return a repository set" do
      assert @user.repositories.is_a?(RepositorySet)
    end
    
    should "be able to find a repository" do
      assert_not_nil @user.repositories.find("octopi")
    end

  end
end
