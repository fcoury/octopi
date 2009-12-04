require File.join(File.dirname(__FILE__), 'test_helper')

class RepositoryTest < Test::Unit::TestCase
  include Octopi
  
  def setup
    fake_everything
    @user = User.find("fcoury")
    @private_repos = auth do
      @private = @user.repositories.find("rboard")
      @user.repositories
    end
    @repository = @user.repositories.find("octopi")
  end

  
  context Repository do
    
    should "not retry for a repository you don't have access to" do
      FakeWeb.register_uri(:get, "#{yaml_api}/repos/show/github/github", :status => 403)
      
      exception = assert_raise APIError do
        Repository.find(:user => "github", :name => "github")
      end
      
      assert_equal exception.message, "Github returned status 403, you may not have access to this resource."
    end
    
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
      assert_equal 45, @user.repositories.size
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
    
    should "be able to search for similar repositories" do
      repos = Repository.search("ruby", "testing")
      assert_not_nil repos
      assert repos.first.is_a?(Repository)
    end
    
    should "be able to find the latest 30 commits" do
      commits = @repository.commits
      assert_not_nil commits
      assert_equal 30, commits.size
    end
    
    
    should "be able to find all open issues" do
      issues = @repository.issues
      assert_not_nil issues
      assert_equal 21, issues.size
    end
    
    should "be able to find all issues" do
      issues = @repository.all_issues
      assert_not_nil issues
      assert_equal 42, issues.size
    end
    
    should "be able to find an issue" do
      assert_not_nil @repository.issue(28)
    end
    
    should "be able to find all collaborators" do
      @collaborators = @repository.collaborators
      assert_not_nil @collaborators
      assert_equal 1, @collaborators.size
      assert @collaborators.first.is_a?(User)
    end
    
    should "be able to create a repository" do
      auth do 
        Repository.create(:name => "octopus")
      end
    end
    
    should "be able to delete a repository" do
      auth do
        @repository.delete!
      end
    end
    
    should "not be able to create a repository when not authed" do
      assert_raise Octopi::AuthenticationRequired do
        Repository.create(:name => "octopus")
      end
    end
    
    should "be able to retrieve the branches" do
      branches = @repository.branches
      assert_not_nil branches
      assert_equal 4, branches.size
    end
    
    should "be able to retrieve the tags" do
      tags = @repository.tags
      assert_not_nil tags
      assert_equal 9, tags.size
    end
    
    should "be able to retrieve the comments" do
      assert_not_nil @repository.comments
      comment = @repository.comments.first
      [:content, :author, :title, :updated, :link, :published, :id, :repository, :commit].each do |f|
        assert_not_nil comment.send(f)
      end
    end
    
    should "return the correct clone URL" do
      assert_equal "git://github.com/fcoury/octopi.git", @repository.clone_url
      auth do
        assert_equal "git@github.com:fcoury/rboard.git", @private.clone_url
      end
    end
      

  end
end
