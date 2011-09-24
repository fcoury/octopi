require 'spec_helper'

describe Octopi::Repository do
  it("is aliased") { Octopi::Repo.should == Octopi::Repository }
  context "getting lists of repositories" do

    it "by user" do
      api_stub("users/rails3book/repos")
      repos = Octopi::Repo.by_user("rails3book")
      repo = repos.first
      repo.pushed_at.should == "2011-04-15T05:22:07Z"
      repo.created_at.should == "2010-05-10T06:40:40Z"
      repo.forks.should == 10
      repo.description.should == "The app for Rails 3 in Action, back when it covered Rails 3.0 (prerelease of the book)"
      repo.clone_url.should == "https://github.com/rails3book/ticketee-old.git"
      repo.ssh_url.should == "git@github.com:rails3book/ticketee-old.git"
      repo.svn_url.should == "https://svn.github.com/rails3book/ticketee-old"
      repo.html_url.should == "https://github.com/rails3book/ticketee-old"
      repo.git_url.should == "git://github.com/rails3book/ticketee-old.git"
      repo.master_branch.should == nil
      repo.language.should == "Ruby"
      repo.fork.should be_false
      repo.homepage.should == ""
      repo.open_issues.should == 4
      repo.private.should be_false
      repo.size.should == 3324
      repo.owner.should be_is_a(Octopi::User)
      repo.name.should == "ticketee-old"
      repo.updated_at.should == "2011-08-28T19:14:37Z"
      repo.watchers.should == 44
      repo.id.should == 658599
      repo.url.should == "https://api.github.com/repos/rails3book/ticketee-old"
    end
    
    it "by organisation" do
      api_stub("orgs/carlhuda/repos")
      repos = Octopi::Repo.by_organization("carlhuda")
      repo = repos.first
      repo.name.should == "thor"
    end
  end
end