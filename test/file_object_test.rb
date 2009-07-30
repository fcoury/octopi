require File.join(File.dirname(__FILE__), 'test_helper')

class FileObjectTest < Test::Unit::TestCase
  include Octopi
  
  def setup
    fake_everything
    @user = User.find("fcoury")
    @repo = @user.repositories.find("octopi")
  end
  
  context "finding" do
    context "with strings" do
      should "work" do
        FileObject.find(:user => "fcoury", :repository => "octopi", :sha => "f6609209c3ac0badd004512d318bfaa508ea10ae")
      end
    end
    
    context "with objects" do
      should "work" do
        FileObject.find(:user => @user, :repository => @repo, :sha => "f6609209c3ac0badd004512d318bfaa508ea10ae")
      end
    end
  end
  
end

