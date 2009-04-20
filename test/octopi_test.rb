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
  
  should "fetch the same issue using different but equivalent find_all params" do
    user = User.find("bcalloway")
    assert_equal user.login, "bcalloway"

    repo = user.repository("myproject")
    assert_equal repo.name, "myproject"

    assert_find_all Issue, :number, repo, user
  end

  should "fetch the same commit using different but equivalent find_all params" do
    user = User.find("fcoury")
    assert_equal user.login, "fcoury"

    repo = user.repository("octopi")
    assert_equal repo.name, "octopi"

    assert_find_all Commit, :id, repo, user
  end
end
