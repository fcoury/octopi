require File.join(File.dirname(__FILE__), 'test_helper')

class RepositoryTest < Test::Unit::TestCase
  include Octopi
  
  def setup
    fake_everything
    @user = User.find("fcoury")
    @private_repos = auth do
      @user.repositories
    end
    @repository = @user.repositories.find("octopi")
  end

  
  context Repository do
    
    should "return a repository for a user" do
      assert_not_nil @user.repository(:name => "octopi")
      assert @user.repository(:name => "octopi").is_a?(Repository)
    end
    
    should "return a repository for a login" do
      assert_not_nil Repository.find(:user => "fcoury", :name => "octopi")
    end
    
    should "be able to look up the repository based on the user and name" do
      assert_not_nil Repository.find(:user => @user, :name => "octopi")
    end
      
    should "have a User as the owner" do
      assert @repository.owner.is_a?(User)
    end
    
    should "return repositories" do
      assert_equal 43, @user.repositories.size
    end
    
    should "return more repositories if authed" do
      assert_equal 44, @private_repos.size
    end
    
    should "not return a repository when asked for a private one" do
      exception = assert_raise NotFound do
        @user.repository(:name => "rboard")
      end
      
      assert_equal "The Repository you were looking for could not be found, or is private.", exception.message
    end
    
    should "return a private repository when authed" do
      auth do
        assert_not_nil @user.repository(:name => "rboard")
      end
    end
    
    should "be able to retrieve the comments" do
      assert_not_nil @repository.comments
      comment = @repository.comments.first
      [:content, :author, :title, :updated, :link, :published, :id, :repository, :commit].each do |f|
        assert_not_nil comment.send(f)
      end
    end
  end
end
