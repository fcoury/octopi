# Tests for octopi core functionality go here.
require File.join(File.dirname(__FILE__), 'test_helper')

class OctopiTest < Test::Unit::TestCase
  include Octopi
  
  def setup
    fake_everything
  end
  
  def default_test
    assert true
  end

end
