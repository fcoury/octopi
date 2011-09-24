require 'spec_helper'

describe Octopi::Gist::GistFile do
  let(:gist) { Octopi::Gist.find(1236602) }
  let(:gist_url) { base_url + "gists/1236602" }
  before do
    stub_request(:get, gist_url).to_return(fake("/gists/1236602"))
    stub_request(:get, gist_url + "/comments").to_return(fake("/gists/1236602/comments"))
  end

  context "unauthenticated" do
    it "cannot remove a file" do
      lambda { gist.files.first.delete! }.should raise_error(Octopi::NotAuthenticated)
    end
  end

  context "authenticated" do
    let(:gist_url) { authenticated_base_url + "gists/1236602" }
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
      WebMock.should have_requested(:post, gist_url).with(:body => '{"files":{"file.rb":"puts \'hello earth\'"}}')
    end

    it "modifies a file" do
      stub_request(:post, gist_url).to_return(fake("gists/modified_a_file"))
      stub_request(:get, gist_url).to_return(fake("gists/1236602"))
      gist.files.first.content = "print 'print rocks!'"
      gist.files.first.save
      WebMock.should have_requested(:post, gist_url).with(:body => '{"files":{"hello.rb":"print \'print rocks!\'"}}')
    end

    it "removes a file" do
      stub_request(:post, gist_url).to_return(fake("/gists/deleted_a_file"))
      gist.files.count.should == 1
      gist.files.first.delete!
      gist.files.count.should == 0
    end
  end
end