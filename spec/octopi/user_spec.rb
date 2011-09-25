require 'spec_helper'

describe Octopi::User do
  before do
    api_stub("users/fcoury")
    api_stub("users/fcoury/gists")
  end

  it "can find a user" do
    user = Octopi::User.find("fcoury")
    user.login.should == "fcoury"
  end
  
  it "can find the authenticated user" do
    Octopi.authenticate!(:username => "radar", :password => "password")
    stub_request(:get, authenticated_base_url + "user").to_return(fake("users/me"))
    user = Octopi::User.me
    user.login.should == "radar"
  end
  
  it "can find a user's gist" do
    Octopi::User.find("fcoury").gists
  end
end