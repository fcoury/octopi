require 'spec_helper'

describe Octopi::Repo do
  context "getting lists of repositories" do
    
    context "unauthenticated" do
      it "by user" do
        api_stub("users/rails3book/repos")
        repos = Octopi::Repo.by_user("rails3book")
        repos.first.is_a?(Octopi::Repo)
      end
    
      it "by organisation" do
        api_stub("orgs/carlhuda/repos")
        repos = Octopi::Repo.by_organization("carlhuda")
        repo = repos.first
        repo.name.should == "thor"
      end
      
      it "finds an organization's repo's organization" do
        api_stub("repos/carlhuda/bundler")
        repo = Octopi::Repo.find("carlhuda/bundler")
        repo.organization.should be_is_a(Octopi::Organization)
      end
    end
    
    context "for a public repo" do
      context "unauthenticated" do
        let(:repo) { Octopi::Repo.find("fcoury/octopi") }
        before do
          api_stub("repos/fcoury/octopi")
        end
        it "finding" do
          repo.pushed_at.should == "2011-09-25T00:02:51Z"
          repo.created_at.should == "2009-04-18T04:26:58Z"
          repo.forks.should == 52
          repo.description.should == "A Ruby interface to GitHub API v2"
          repo.clone_url.should == "https://github.com/fcoury/octopi.git"
          repo.ssh_url.should == "git@github.com:fcoury/octopi.git"
          repo.svn_url.should == "https://svn.github.com/fcoury/octopi"
          repo.html_url.should == "https://github.com/fcoury/octopi"
          repo.git_url.should == "git://github.com/fcoury/octopi.git"
          repo.master_branch.should == nil
          repo.language.should == "Ruby"
          repo.fork.should be_false
          repo.homepage.should == "http://hasmany.info/2009/4/18/ruby-interface-to-github-api"
          repo.open_issues.should == 18
          repo.private.should be_false
          repo.size.should == 180
          repo.owner.should be_is_a(Octopi::User)
          repo.name.should == "octopi"
          repo.updated_at.should == "2011-09-25T00:02:51Z"
          repo.watchers_count.should == 240
          repo.id.should == 179067
          repo.url.should == "https://api.github.com/repos/fcoury/octopi"
        end
    
        it "branches" do
          api_stub("repos/fcoury/octopi/branches")
          branches = repo.branches
          branches.first.is_a?(Octopi::Branch).should be_true
        end
        
        it "comments" do
          api_stub("repos/fcoury/octopi/comments")
          comments = repo.comments
          comments.first.is_a?(Octopi::Comment).should be_true
        end
        
        context "collaborators" do
          it "listing" do
            api_stub("repos/fcoury/octopi/collaborators")
            collaborators = repo.collaborators
            collaborators.first.is_a?(Octopi::User).should be_true
          end
        
          it "adding"
          it "deleting"
        end

        it "detects if a user is a collaborator" do
          api_stub("users/fcoury")
          api_stub("repos/fcoury/octopi/collaborators/fcoury")
          repo.is_collaborator?(Octopi::User.find("fcoury")).should be_true
        end

        it "detects if a user is a collaborator by login" do
          api_stub("repos/fcoury/octopi/collaborators/fcoury")
          repo.is_collaborator?("fcoury").should be_true
        end

        it "user is not a collaborator" do
          api_stub("repos/fcoury/octopi/collaborators/dhh")
          repo.is_collaborator?("dhh").should be_false
        end

        it "languages" do
          api_stub("repos/fcoury/octopi/languages")
          languages = repo.languages
          languages.first.name.should == "Ruby"
        end
        
        it "tags" do
          api_stub("repos/fcoury/octopi/tags")
          tags = repo.tags
          tags.first.is_a?(Octopi::Tag).should be_true
          tags.first.name.should == "v0.1.0"
        end
        
        it "teams" do
          pending("always returns a 404? Need repo with teams")
        end
        
        it "cannot update this repository" do
          lambda { repo.update(:description => "omg") }.should raise_error(Octopi::NotAuthenticated)
        end
        
        context "forks" do
          it "listing"
          it "creates"
        end
        
        context "keys" do
          it "listing"
          it "singular"
          it "creates"
          it "edits"
          it "deletes"
        end
        
        it "watchers"
        
        context "hooks" do
          it "listing"
          it "singular"
          it "creates"
          it "edits"
          it "tests"
          it "deletes"
          it "pubsubhubbub"
        end
      end
      
      context "authenticated" do
        let(:repo) { Octopi::Repo.find("radar/octopi") }
        before do
          Octopi.authenticate! :username => "radar", :password => "password"
        end
        
        it "can create a repository"
        
        it "can update a repository's detail" do
          authenticated_api_stub("repos/radar/octopi")
          stub_request(:put, "https://radar:password@api.github.com/repos/radar/octopi").to_return(fake("repos/radar/octopi/update"))
          repo.update(:description => "omg")
          WebMock.should have_requested(:put, "https://radar:password@api.github.com/repos/radar/octopi").with(:body => '{"description":"omg"}')
        end

        it "deletes a repository"
      end
    end
    
    context "for a private repo" do
      context "unauthenticated" do
        it "cannot access the repository" do
          stub_request(:get, base_url + "repos/radar/rails3book").to_return(:status => 404)
          message = "The Octopi::Repo you were looking for could not be found or it could be private."
          lambda { Octopi::Repo.find("radar/rails3book") }.should raise_error(Octopi::NotFound, message)
        end
      end
    end
  end
end
