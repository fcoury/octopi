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
      
      # Tests issue #28
      should "be able to find commits in a private repository" do
        auth do
          commits = Commit.find_all(:user => "fcoury", :repository => "rboard")
        end
        assert_not_nil commits
        assert_equal 22, commits.size
      end
      
      should "be able to find commits for a particular file" do
        commits = Commit.find_all(:user => "fcoury", :repository => "octopi", :path => "lib/octopi.rb")
        assert_not_nil commits
        assert_equal 44, commits.size
      end
    end
    
    context "finding a single commit" do
      should "by strings" do
        commit = Commit.find(:name => "octopi", :user => "fcoury", :sha => "f6609209c3ac0badd004512d318bfaa508ea10ae")
        assert_not_nil commit
      end
      
      should "by objects" do
        commit = Commit.find(:name => "octopi", :user => "fcoury", :sha => "f6609209c3ac0badd004512d318bfaa508ea10ae")
        assert_not_nil commit
      end
      
      should "be able to specify a branch" do
        commit = Commit.find(:name => "octopi", :user => "fcoury", :sha => "f6609209c3ac0badd004512d318bfaa508ea10ae", :branch => "lazy")
        assert_not_nil commit
      end
    
      should "raise an error if not found" do
        exception = assert_raise Octopi::NotFound do
          Commit.find(:name => "octopi", :user => "fcoury", :sha => "nothere")
        end
        
        assert_equal "The Commit you were looking for could not be found, or is private.", exception.message
      end
    end
    
    context "identifying a repository" do
      should "be possible" do
        commit = Commit.find(:name => "octopi", :user => "fcoury", :sha => "f6609209c3ac0badd004512d318bfaa508ea10ae")
        assert_equal "fcoury/octopi/f6609209c3ac0badd004512d318bfaa508ea10ae", commit.repo_identifier
      end
    end
  end
end

