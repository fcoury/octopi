require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'fakeweb'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'octopi'

@the_repo = ["fcoury", "octopi"]

def stub_file(*path)
  File.join(File.dirname(__FILE__), "stubs", path)
end

def commits(*args)
  File.join("commits", "fcoury", "octopi", args)
end

def issues(*args)
  File.join("issues", "fcoury", "octopi", args)
end

def repos(*args)
  File.join("repos", "fcoury", "octopi", args)
end

def fake_everything
  # helper variables to make things shorter.
  sha = "f6609209c3ac0badd004512d318bfaa508ea10ae"
  yaml_api = "github.com/api/v2/yaml"
  plain_api = "github.com:80/api/v2/plain"
  # Set this to true or comment out if you want to test against real data
  # Which, in a theoretical world should Just Work (tm)
  # This is of course with the exception of the authenticated tests
  FakeWeb.allow_net_connect = false
  
  # Public stuff
  fakes = {
       
        "blob/show/fcoury/octopi/#{sha}" => File.join("blob", "fcoury", "octopi", "plain", sha),
        
        "commits/list/fcoury/octopi/master" => commits("master"),
        "commits/list/fcoury/octopi/lazy" => commits("lazy"),
        "commits/show/fcoury/octopi/#{sha}" => commits(sha),
        
        "issues/close/fcoury/octopi/28" => issues("28-closed"),
        "issues/edit/fcoury/octopi/28" => issues("28-edited"), 
        "issues/list/fcoury/octopi/open" => issues("open"),
        "issues/list/fcoury/octopi/closed" => issues("closed"),
        "issues/open/fcoury/octopi" => issues("new"),
        "issues/reopen/fcoury/octopi/27" => issues("27-reopened"),
        
        "issues/comment/fcoury/octopi/28" => issues("comment", "28-comment"),
        
        "issues/label/add/fcoury/octopi/one-point-oh/28" => issues("labels", "28-one-point-oh"),
        "issues/label/add/fcoury/octopi/maybe-two-point-oh/28" => issues("labels", "28-maybe-two-point-oh"),
        "issues/label/remove/fcoury/octopi/one-point-oh/28" => issues("labels", "28-remove-one-point-oh"),
        "issues/label/remove/fcoury/octopi/maybe-two-point-oh/28" => issues("labels", "28-remove-maybe-two-point-oh"),
    
    
        # Closed issue
        "issues/show/fcoury/octopi/27" => issues("27"),
        # Open issue
        "issues/show/fcoury/octopi/28" => issues("28"),
        
        "repos/show/fcoury" => File.join("repos", "show", "fcoury"),
        "repos/show/fcoury/octopi" => repos("main"),
        "repos/show/fcoury/octopi/branches" => repos("branches"),
        
        "tree/show/fcoury/octopi/#{sha}" => File.join("tree", "fcoury", "octopi", sha),
        
        "user/show/fcoury" => File.join("users", "fcoury")
        
          }
  
  fakes.each do |key, value|
    FakeWeb.register_uri("http://#{yaml_api}/" + key, :string => YAML::load_file(stub_file(value)))
  end
  
  # rboard is a private repository
  FakeWeb.register_uri("http://#{yaml_api}/repos/show/fcoury/rboard", :string => YAML::load_file(stub_file("errors", "repository", "not_found")))
  
  # nothere is obviously an invalid sha
  FakeWeb.register_uri("http://#{yaml_api}/commits/show/fcoury/octopi/nothere", :status => ["404", "Not Found"])
  # not-a-number is obviously not a number
  FakeWeb.register_uri("http://#{yaml_api}/issues/show/fcoury/octopi/not-a-number", :status => ["404", "Not Found"])
  # Personal & Private stuff
  
  secure_fakes = {
    "user/show/fcoury" => File.join("users", "fcoury-private"),
    "repos/show/fcoury" => File.join("repos", "show", "fcoury-private"),
    "repos/show/fcoury/octopi" => File.join("repos", "fcoury", "octopi", "main"),
    "repos/show/fcoury/rboard" => File.join("repos", "fcoury", "rboard", "main")
  }
  
  secure_fakes.each do |key, value|
    FakeWeb.register_uri("https://#{yaml_api}/" + key, :string => YAML::load_file(stub_file(value)))
  end
  
  # And the plain fakes
  FakeWeb.register_uri("http://#{plain_api}/blob/show/fcoury/octopi/#{sha}", 
  :string => File.read(stub_file(File.join("blob", "fcoury", "octopi", "plain", sha))))
  
  
  FakeWeb.register_uri("http://github.com/fcoury/octopi/comments.atom", :string => File.read(stub_file("comments", "fcoury", "octopi", "comments.atom")))
end


class Test::Unit::TestCase
  
end
