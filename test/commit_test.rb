require File.join(File.dirname(__FILE__), 'test_helper')

class CommitTest < Test::Unit::TestCase
  include Octopi
  
  def setup
    fake_everything
    @user = User.find("fcoury")
    @repo = @user.repository("octopi")
  end

  context Commit do
    should "fetch the same commit using different but equivalent find_all params" do
      assert_find_all Commit, :id, @repo, @user
    end
  end
end

