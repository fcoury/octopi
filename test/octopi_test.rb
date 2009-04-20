require 'test_helper'

class OctopiTest < Test::Unit::TestCase
  include Octopi
  
  # TODO: Those tests are obviously brittle. Need to stub/mock it.
  
  def assert_find_all(cls, check_method, repo, user)
    repo_method = cls.resource_name(:plural)
    
    item1 = cls.find_all(user.login, repo.name).first
    item2 = cls.find_all(repo).first
    item3 = repo.send(repo_method).first
    
    assert_equal item1.send(check_method), item2.send(check_method)
    assert_equal item1.send(check_method), item3.send(check_method)
  end
  
  def setup
    @user = User.find("fcoury")
    @repo = @user.repository("octopi")
    @issue = @repo.issues.first
  end
  
  context Issue do
    should "return the correct issue by number" do
      assert_equal @issue.number, Issue.find(@repo, @issue.number).number
      assert_equal @issue.number, Issue.find(@user, @repo, @issue.number).number
      assert_equal @issue.number, Issue.find(@repo.owner, @repo.name, @issue.number).number
    end

    should "return the correct issue by using repo.issue number" do
      assert_equal @issue.number, @repo.issue(@issue.number).number
    end
    
    should "fetch the same issue using different but equivalent find_all params" do
      assert_find_all Issue, :number, @repo, @user
    end
  end

  context Commit do
    should "fetch the same commit using different but equivalent find_all params" do
      assert_find_all Commit, :id, @repo, @user
    end
  end
end
