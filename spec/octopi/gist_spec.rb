require 'spec_helper'

describe Octopi::Gist do

  context "unauthenticated" do
    it "can find all a user's gists" do
      api_stub("users/fcoury/gists")
      gists = Octopi::Gist.for_user("fcoury")
      gists.count.should == 30
    end
    
    it "can create an anonymous gist" do
      stub_request(:post, base_url + "gists").to_return(fake("gists/create_anonymously"))
      gist = Octopi::Gist.create(:files => { "file.rb" => { :content => "puts 'hello world'" }})
      gist.owner.should be_nil
      # Check ensuring that public=true is sent through.
      WebMock.should have_requested(:post, base_url + "gists").with(:body => "files[file.rb][content]=puts%20'hello%20world'&public=true")
    end
    
    it "cannot retreive starred gists" do
      lambda { Octopi::Gist.starred }.should raise_error(Octopi::NotAuthenticated)
    end
    
    context "working with a gist" do
      let(:gist) { Octopi::Gist.find(1236602) }
      before do
        api_stub("gists/1236602")
        api_stub("gists/1236602/comments")
      end

      it "cannot star it" do
        lambda { gist.star! }.should raise_error(Octopi::NotAuthenticated)
      end
    
      it "cannot unstar it" do
        lambda { gist.unstar! }.should raise_error(Octopi::NotAuthenticated)
      end
    end
  end
  
  context "authenticated" do
    before do
      Octopi.authenticate! :username => "radar", :password => "password"
    end
    
    it "can create a public gist" do
      stub_request(:post, authenticated_base_url + "gists").to_return(fake("gists/create"))
      gist = Octopi::Gist.create(:files => { "file.rb" => { :content => "puts 'hello world'" }})
      # Check ensuring that public=true is sent through and request is authenticated
      # TODO: Why are these params reversed from the private example?
      WebMock.should have_requested(:post, authenticated_base_url + "gists").with(:body => "files[file.rb][content]=puts%20'hello%20world'&public=true")

      gist.owner.login.should == "radar"
    end
    
    it "can create a private gist" do
      stub_request(:post, authenticated_base_url + "gists").to_return(fake("gists/create_private"))
      gist = Octopi::Gist.create(:public => false, :files => { "file.rb" => { :content => "puts 'hello world'" }})
      # TODO: Why are these params reversed from the public example?
      WebMock.should have_requested(:post, authenticated_base_url + "gists").with(:body => "public=false&files[file.rb][content]=puts%20'hello%20world'")
      
      gist.owner.login.should == "radar"
    end
    
    context "as rails3book" do
      let(:gists_url) { authenticated_base_url("rails3book") + "gists" }
      before do
        # For hopefully obvious reasons...
        # I don't want to show you my private gists.
        # BECAUSE THEY ARE PRIVATE.
        # Geez.
        stub_successful_login!("rails3book")
        Octopi.authenticate! :username => "rails3book", :password => "password"
      end

      it "can retreive own gists" do
        stub_request(:get, gists_url).to_return(fake("gists"))
        
        gists = Octopi::Gist.mine
        # There should be at least one private gist
        gists.any? { |gist| gist.public == false }.should be_true
        WebMock.should have_requested(:get, gists_url)
      end
      
      it "can retreive own starred gists" do
        stub_request(:get, gists_url + "/starred").to_return(fake("gists/starred"))
        Octopi::Gist.starred
        WebMock.should have_requested(:get, gists_url + "/starred")
      end
      
      context "working with a gist" do
        let(:gist) { Octopi::Gist.find(1236602) }
        let(:gist_url) { authenticated_base_url("rails3book") + "gists/1236602" }
        
        before do
          stub_request(:get, gist_url).to_return(fake("gists/1236602"))
          stub_request(:get, gist_url + "/comments").to_return(fake("gists/1236602/comments"))
        end

        context "starring" do
          let(:star_url) { "https://rails3book:password@api.github.com/gists/1236602/star" }
          before do
            authenticated_api_stub("gists/1236602/star", "rails3book")
          end

          it "setting starred status for a gist" do
            stub_request(:put, star_url).to_return(:status => 204)
            gist.star!
            WebMock.should have_requested(:put, star_url)
          end
        
          it "setting unstarred status for a gist" do
            stub_request(:delete, star_url).to_return(:status => 204)
            gist.unstar!
            WebMock.should have_requested(:delete, star_url)          
          end

          it "gist is starred" do
            stub_request(:get, star_url).to_return(:status => 204)
            gist.should be_starred
          end

          it "gist is not starred" do
            stub_request(:get, star_url).to_return(:status => 404)
          end
        end

        it "deletes a gist" do
          gist_url = authenticated_base_url("rails3book") + "gists/1236602"
          stub_request(:get, gist_url).to_return(fake("gists/1236602"))
          stub_request(:get, gist_url + "/comments").to_return(fake("gists/1236602/comments"))
          stub_request(:delete, gist_url).to_return(:status => "204")
          gist.delete
          WebMock.should have_requested(:delete, gist_url)
        end
      
        it "forks a gist" do
          stub_request(:post, authenticated_base_url("rails3book") + "gists/1236602/fork").to_return(fake("gists/fork"))
          new_gist = gist.fork!
          new_gist.id.should_not == gist.id
        end
      end
    end
  end
  
  context "for a gist" do
    let(:gist) { Octopi::Gist.find(1236602) }
    before do
      api_stub("gists/1236602")
      api_stub("gists/1236602/comments")
    end

    it "retreiving user" do
      gist.user.is_a?(Octopi::User).should be_true
    end

    it "retreiving files" do
      gist.files.first.is_a?(Octopi::Gist::GistFile).should be_true
    end

    it "retreiving history" do
      gist.history.first.is_a?(Octopi::Gist::History).should be_true
    end
    
    it "retreiving comments" do
      gist.comments.first.is_a?(Octopi::Gist::Comment).should be_true
    end
    
    it "has attributes" do
      gist.updated_at.should == "2011-09-23T02:32:53Z"
      gist.git_pull_url.should == "git://gist.github.com/1236602.git"
      gist.forks.should == []
      gist.public.should be_true
      gist.description.should == "omg"
      gist.created_at.should == "2011-09-23T02:12:47Z"
      gist.html_url.should == "https://gist.github.com/1236602"
      gist.id.should == "1236602"
    end

    it "links files to gist" do
      gist.files.first.gist.should == gist
    end

    it "links histories to gist" do
      gist.history.first.gist.should == gist
    end

    it "links comments to gist" do
      gist.comments.first.gist.should == gist
    end

    it "updates description" do
      Octopi.authenticate! :username => "radar", :password => "password"
      authenticated_api_stub("gists/1236602")
      authenticated_api_stub("gists/1236602/comments")
      gist = Octopi::Gist.find(1236602)
      url = authenticated_base_url + "gists/1236602"
      attributes = { :description => "New Description" }
      stub_request(:put, url).
         with(:body => attributes.to_json).to_return(fake("gists/update"))

      gist = gist.update(attributes)
      gist.description.should == "New Description"

      WebMock.should have_requested(:put, url)
    end
  end
end
