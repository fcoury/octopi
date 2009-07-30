require File.join(File.dirname(__FILE__), 'test_helper')

class CommitTest < Test::Unit::TestCase
  include Octopi
  
  def setup
    fake_everything
    @user = User.find("fcoury")
    @repo = @user.repository(:name => "octopi")
  end

  context Commit do
    context "finding all commits" do
      should "by strings" do
        commits = Commit.find_all(:user => "fcoury", :repository => "octopi")
        assert_not_nil commits
        assert_equal 30, commits.size
        assert_not_nil commits.first.repository
      end
      
      should "by objects" do
        commits = Commit.find_all(:user => @user, :repository => @repo)
        assert_not_nil commits
        assert_equal 30, commits.size
      end
      
      should "be able to specify a branch" do
        commits = Commit.find_all(:user => "fcoury", :repository => "octopi", :branch => "lazy")
        assert_not_nil commits
        assert_equal 30, commits.size
      end
    end
  end
end

