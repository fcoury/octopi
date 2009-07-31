require File.join(File.dirname(__FILE__), 'test_helper')

class BranchTest < Test::Unit::TestCase
  include Octopi
  
  def setup
    fake_everything
  end

  context Branch do
    should "Find all branches for a repository" do
      assert_not_nil Branch.all(:user => "fcoury", :name => "octopi")
    end
    
    should "Be able to find a specific branch" do
      assert_not_nil Branch.all(:user => "fcoury", :name => "octopi").find("lazy")
    end
  end
end

