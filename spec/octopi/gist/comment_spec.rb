require 'spec_helper'

describe Octopi::Gist::Comment do
  let(:gist) { Octopi::Gist.find(1236602) }
  let(:comment_url) { base_url + "gists/comments/52291" }
  before do
    authenticated_api_stub("gists/1236602")
    authenticated_api_stub("gists/1236602/comments")
    stub_request(:get, comment_url).to_return(fake("gists/comments/52291"))
  end

  it "gets a single comment" do
    Octopi::Gist::Comment.find(52291)
    WebMock.should have_requested(:get, comment_url)
  end

  context "authenticated" do
    let(:comment_url) { authenticated_base_url + "gists/comments/52291" }
    before do
      Octopi.authenticate!(:username => "radar", :password => "password")
    end

    it "can create a comment" do
      url = authenticated_base_url + "gists/1236602/comments"
      stub_request(:post, url).to_return(fake("gists/comments/create"))
      comment = gist.comments.create!(:body => "This is a brand new comment!")
      comment.is_a?(Octopi::Gist::Comment).should be_true
      WebMock.should have_requested(:post, url)
    end
    
    it "updates a comment" do
      stub_request(:post, comment_url).to_return(fake("gists/comments/update"))
      comment = Octopi::Gist::Comment.find(52291)
      comment.update(:body => "This is new content")
      WebMock.should have_requested(:post, comment_url)
    end
    
    it "deletes a comment" do
      stub_request(:delete, comment_url).to_return(:status => 204)
      comment = Octopi::Gist::Comment.find(52291)
      comment.delete
      WebMock.should have_requested(:delete, comment_url)
    end
  end
end