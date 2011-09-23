require 'spec_helper'

describe Octopi::Gist::GistFile do
  let(:gist) { Octopi::Gist.find(1236602) }

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
    
    it "adds a file"
    it "modifies a file"

    it "removes a file" do
      stub_request(:post, authenticated_base_url + "gists/#{gist.id}").to_return(fake("/gists/deleted_a_file"))
      gist.files.count.should == 1
      gist.files.first.delete!
      gist.files.count.should == 0
    end
  end
end