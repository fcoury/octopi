require 'spec_helper'

describe Octopi::Commit do
  let(:repo) { Octopi::Repo.find("fcoury/octopi") }
  before do
    api_stub("repos/fcoury/octopi")
  end
  
  it "commits" do
    api_stub("repos/fcoury/octopi/commits")
    commits = repo.commits
    commits.count.should == 30
    commits.first.is_a?(Octopi::Commit).should be_true
  end
  
  it "commits for sha" do
    api_stub("repos/fcoury/octopi/commits?sha=da8d7e33965c5034c948357d176da2e6b3ac2365")
    commits = repo.commits(:sha => "da8d7e33965c5034c948357d176da2e6b3ac2365")
    commits.count.should == 30
  end

  it "commits for v3 branch" do
    api_stub("repos/fcoury/octopi/commits?sha=v3")
    commits = repo.commits(:branch => "v3")
    commits.count.should == 30
    commits.first.message.should == "Add ability to get commits for a repository"
  end
  
  it "commits for master branch" do
    api_stub("repos/fcoury/octopi/commits?sha=master")
    commits = repo.commits(:branch => "master")
    commits.count.should == 30
    commits.first.message.should == "Merge pull request #68 from nithinbekal/patch-1\n\nFix the incorrect example 2 for explicit authentication. Refs #59"
  end
  
  it "commits for a path" do
    api_stub("repos/fcoury/octopi/commits?path=README.markdown")
    commits = repo.commits(:path => "README.markdown")
    commits.count.should == 9
  end
  
  it "finds a single commit by full sha" do
    api_stub("repos/fcoury/octopi/commits")
    api_stub("repos/fcoury/octopi/commits/38b679a92a49bb49a72e57d99639e26830b7792b")
    commit = repo.commits.find("38b679a92a49bb49a72e57d99639e26830b7792b")
    commit.message.should == "Merge pull request #68 from nithinbekal/patch-1\n\nFix the incorrect example 2 for explicit authentication. Refs #59"
  end
  
  it "finds a single commit by short sha" do
    api_stub("repos/fcoury/octopi/commits")
    api_stub("repos/fcoury/octopi/commits/38b679")
    commit = repo.commits.find("38b679")
    commit.message.should == "Merge pull request #68 from nithinbekal/patch-1\n\nFix the incorrect example 2 for explicit authentication. Refs #59"
    commit.sha.should == "38b679a92a49bb49a72e57d99639e26830b7792b"
  end
end