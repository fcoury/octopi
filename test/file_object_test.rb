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
    
    context "invalid sha" do
      should "not work" do
        # sha below is "ryan"
        FileObject.find(:user => @user, :repository => @repo, :sha => "ea3cd978650417470535f3a4725b6b5042a6ab59")
      end
    end
  end
  
end

