require File.join(File.dirname(__FILE__), 'test_helper')

class BranchTest < Test::Unit::TestCase
  include Octopi
  
  def setup
    fake_everything
  end

  context Branch do
    should "find the branches" do
      assert_not_nil Branch.find("fcoury", "octopi")
    end
    
    should "not find a branch that doesn't exist" do
      assert_raises NotFound do
        Branch.all("fcoury", "octopi").find("false")
      end
    end
  end
end

