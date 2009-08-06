require File.join(File.dirname(__FILE__), 'test_helper')

class GistTest < Test::Unit::TestCase
  include Octopi
  
  def setup
    fake_everything
  end

  context Gist do
    should "Find a single gist" do
      assert_not_nil Gist.find(159579)
    end
  end
end

