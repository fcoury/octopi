require 'spec_helper'

describe Octopi::User do
  it "can find a user" do
    user = Octopi::User.find("fcoury")
    user.login.should == "fcoury"
  end
end