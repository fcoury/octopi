require File.join(File.dirname(__FILE__), 'test_helper')

class BlobTest < Test::Unit::TestCase
  include Octopi
  
  def setup
    fake_everything
  end

  context Blob do
    should "find a blob" do
      blob = Blob.find("fcoury", "octopi", "f6609209c3ac0badd004512d318bfaa508ea10ae")
      assert_not_nil blob
      assert blob.is_a?(String)
    end
    
    # Can't grab real data for this yet, Github is throwing a 500 on this request.
    should "find a file for a blob" do
     assert_not_nil Blob.find("fcoury", "octopi", "f6609209c3ac0badd004512d318bfaa508ea10ae", "lib/octopi.rb")
    end
  end
end

