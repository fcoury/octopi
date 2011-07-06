require File.expand_path(File.join(File.dirname(__FILE__), 'test_helper'))

class TreeTest < Test::Unit::TestCase
  include Octopi

  def setup
    fake_everything
  end
  
  should "be able to find a tree set" do
    shared_options = { :user => "fcoury", :repo => "octopi"}
    branch = Branch.all(shared_options).detect { |b| b.name == "master" }
    assert Tree.find(shared_options.merge!(:sha => branch.sha)).is_a?(TreeSet)
  end
end
