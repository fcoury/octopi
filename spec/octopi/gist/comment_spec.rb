require 'spec_helper'

describe Octopi::Gist::Comment do
  let(:gist) { Octopi::Gist.find(1236602) }
  before do
    authenticated_api_stub("gists/1236602")
    authenticated_api_stub("gists/1236602/comments")
  end

  it "gets a single comment" do
    url = base_url + "gists/comments/52291"
    stub_request(:get, url).to_return(fake("gists/comments/52291"))
    Octopi::Gist::Comment.find(52291)
    WebMock.should have_requested(:get, url)
  end

  context "authenticated" do
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
  end
end