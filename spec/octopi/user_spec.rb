require 'spec_helper'

describe Octopi::User do
  it "can find a user" do
    user = Octopi::User.find("fcoury")
    user.login.should == "fcoury"
  end
  
  it "can find a user's gist" do
    Octopi::User.find("fcoury").gists
  end
end