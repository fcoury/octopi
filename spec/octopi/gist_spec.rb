require 'spec_helper'

describe Octopi::Gist do
  it "can find all a user's gists" do
    gists = Octopi::Gist.for_user("fcoury")
    gists.count.should == 30
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