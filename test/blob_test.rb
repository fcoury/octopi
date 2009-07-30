require File.join(File.dirname(__FILE__), 'test_helper')

class BlobTest < Test::Unit::TestCase
  include Octopi
  
  def setup
    fake_everything
  end

  context Blob do
    should "find a blob" do
      assert_not_nil Blob.find("fcoury", "octopi", "f6609209c3ac0badd004512d318bfaa508ea10ae")
    end
  end
end

