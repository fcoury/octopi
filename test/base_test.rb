require File.join(File.dirname(__FILE__), 'test_helper')

class BaseTest < Test::Unit::TestCase
  class SparseUser < Octopi::Base
    include Octopi::Resource
    
    attr_accessor :some_attribute
    
    find_path "/user/search/:query"
    resource_path "/user/show/:id"
  end
  
  def setup
    fake_everything
  end
  
  should "not raise an error if it doesn't know about the attributes that GitHub API provides" do
    assert_nothing_raised { SparseUser.find("radar") }
  end
end