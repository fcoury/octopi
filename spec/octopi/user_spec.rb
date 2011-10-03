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

  it "can find a user's gists" do
    Octopi::User.find("fcoury").gists
  end
  
  it "can find a user's watched repositories" do
    api_stub("user/fcoury/watched")
    watched = Octopi::User.find("fcoury").watched
    watched.first.is_a?(Octopi::Repo).should be_true
    WebMock.should have_requested(:get, base_url + "user/fcoury/watched")
  end

  context "authenticated" do
    let(:url) { authenticated_base_url + "user" }
    before do
      Octopi.authenticate!(:username => "radar", :password => "password")
      stub_request(:get, authenticated_base_url + "user").to_return(fake("users/me"))
    end

    it "can find the authenticated user" do
      user = Octopi::User.me
      user.login.should == "radar"
    end
  
    it "can update the authenticated user's details" do
      user = Octopi::User.me
      user.name.should == "Ryan Bigg"
      stub_request(:put, url).to_return(fake("users/updated"))
      user = Octopi::User.update(:name => "Super Ryan")

      WebMock.should have_requested(:put, url).with(:body => { :name => "Super Ryan"}.to_json)
      user.name.should == "Super Ryan"
    end
    
    it "watched repositories" do
      pending("May require changes to how Octopi::User.me works. Maybe it should return a proxy Octopi::Me object that inherits from User and acts *slightly* different?")
    end

    it "watching a repo?"
    it "watch a repo"
    it "stop watching a repo"
  end
end