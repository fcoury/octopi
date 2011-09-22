require 'spec_helper'

describe Octopi::Gist do
  context "unauthenticated" do
    it "can find all a user's gists" do
      gists = Octopi::Gist.for_user("fcoury")
      gists.count.should == 30
    end
    
    it "can create an anonymous gist" do
      gist = Octopi::Gist.create(:files => { "file.rb" => { :content => "puts 'hello world'" }})
      gist.owner.should be_nil
      # Check ensuring that public=true is sent through.
      WebMock.should have_requested(:post, base_uri + "gists").with(:body => "files[file.rb][content]=puts%20'hello%20world'&public=true")
    end
  end
  
  context "authenticated" do
    before do
      Octopi.authenticate_with! :user => "user", :password => "token"
    end
    
    it "can create a public gist" do
      gist = Octopi::Gist.create(:files => { "file.rb" => { :content => "puts 'hello world'" }})
      gist.owner.should be_nil

      # Check ensuring that public=true is sent through.
      WebMock.should have_requested(:post, base_uri + "gists").with(:body => "files[file.rb][content]=puts%20'hello%20world'&public=true")
    end
    
    it "can create a private gist" do
      Octopi::Gist.create(:public => false, :files => { "file.rb" => { :content => "puts 'hello world'" }})
      WebMock.should have_requested(:post, base_uri + "gists").with(:body => "files[file.rb][content]=puts%20'hello%20world'&public=false")
    end
    
    it "can retreive own public gists" do
      Octopi::Gist.mine
    end
    
    
    it "can retreive own starred gists" do
      Octopi::Gist.starred
    end
  end
  
  context "for a gist" do
    let(:gist) { Octopi::Gist.find(1115247) }

    it "retreiving user" do
      gist.user.is_a?(Octopi::User).should be_true
    end

    it "retreiving files" do
      gist.files.first.is_a?(Octopi::Gist::GistFile).should be_true
    end

    it "retreiving history" do
      gist.history.first.is_a?(Octopi::Gist::History).should be_true
    end
    
    it "has attributes" do
      gist.updated_at.should == "2011-07-30T05:53:43Z"
      gist.git_pull_url.should == "git://gist.github.com/1115247.git"
      gist.forks.should == []
      gist.public.should be_true
      gist.description.should == ""
      gist.created_at.should == "2011-07-30T05:53:43Z"
      gist.html_url.should == "https://gist.github.com/1115247"
      gist.id.should == "1115247"
    end
  end
end