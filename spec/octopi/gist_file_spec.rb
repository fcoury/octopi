require 'spec_helper'

describe Octopi::Gist::GistFile do
  let(:gist) { Octopi::Gist.find(1236602) }
  let(:gist_url) { authenticated_base_url + "gists/1236602" }
  before do
    stub_request(:get, gist_url).to_return(fake("/gists/1236602"))
  end

  context "unauthenticated" do
    it "cannot remove a file" do
      lambda { gist.files.first.delete! }.should raise_error(Octopi::NotAuthenticated)
    end
  end

  context "authenticated" do
    before do
      stub_successful_login!
      Octopi.authenticate!(:username => "radar", :password => "password")
    end
    
    it "adds a file" do
      gist.files.count.should == 1
      stub_request(:post, gist_url).to_return(fake("gists/added_a_file"))
      stub_request(:get, gist_url).to_return(fake("gists/added_a_file"))
      gist.add_file!("file.rb", "puts 'hello earth'")
      gist.files.count.should == 2
    end
    it "modifies a file"

    it "removes a file" do
      stub_request(:post, gist_url).to_return(fake("/gists/deleted_a_file"))
      gist.files.count.should == 1
      gist.files.first.delete!
      gist.files.count.should == 0
    end
  end
end