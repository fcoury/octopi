# Tests for octopi core functionality go here.
require File.join(File.dirname(__FILE__), 'test_helper')

class TagTest < Test::Unit::TestCase
  include Octopi
  
  def setup
    fake_everything
  end
  
  context Tag do
    should "be able to find all tags" do
      tags = Tag.all(:user => "fcoury", :repository => "octopi")
      assert_not_nil tags
      assert 12, tags.size
      assert tags.first.is_a?(Tag)
    end
  end

end
