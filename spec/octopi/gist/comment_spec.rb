require 'spec_helper'

describe Octopi::Gist::Comment do
  it "gets a single comment" do
    url = base_url + "gists/comments/52291"
    stub_request(:get, url).to_return(fake("gists/comments/52291"))
    Octopi::Gist::Comment.find(52291)
    WebMock.should have_requested(:get, url)
  end
end