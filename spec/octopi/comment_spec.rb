require 'spec_helper'

describe Octopi::Comment do
  it "has attributes" do
    api_stub("repos/fcoury/octopi")
    api_stub("repos/fcoury/octopi/comments")
    repo = Octopi::Repo.find("fcoury/octopi")
    comment = repo.comments.first
    comment.updated_at.should == "2009-12-15T09:31:19Z"
    comment.line.should be_nil
    comment.body.should_not == ""
    comment.commit_id.should == "a25074f259704821c3193764705a6ad14bede628"
    comment.created_at.should == "2009-12-15T09:31:19Z"
    comment.position.should be_nil
    comment.user.is_a?(Octopi::User).should be_true
    comment.id.should == 38684
    comment.url.should == "https://api.github.com/repos/fcoury/octopi/comments/38684"
  end
end