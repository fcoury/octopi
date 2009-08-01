require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'fakeweb'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
ENV['HOME'] = File.dirname(__FILE__)
# Set this to true or comment out if you want to test against real data
# Which, in a theoretical world should Just Work (tm)
# This is of course with the exception of the authenticated tests and
# those tests that require modification of things. Be wary. 
REAL_WORLD = false
FakeWeb.allow_net_connect = REAL_WORLD
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

def auth(&block)
  authenticated_with(:login => "fcoury", :token => "8f700e0d7747826f3e56ee13651414bd") do
    yield
  end
end

# Methodized so it can be used in tests, an instance would do also.
def yaml_api
  "github.com/api/v2/yaml"
end

def fake_everything
  # helper variables to make things shorter.
  sha = "f6609209c3ac0badd004512d318bfaa508ea10ae"
  fake_sha = "ea3cd978650417470535f3a4725b6b5042a6ab59"

  plain_api = "github.com:80/api/v2/plain"
  
  # Public stuff
  fakes = {       
        "blob/show/fcoury/octopi/#{sha}" => File.join("blob", "fcoury", "octopi", "plain", sha),
        
        "commits/list/fcoury/octopi/master" => commits("master"),
        "commits/list/fcoury/octopi/lazy" => commits("lazy"),
        "commits/show/fcoury/octopi/#{sha}" => commits(sha),
        
        "issues/list/fcoury/octopi/open" => issues("open"),
        "issues/list/fcoury/octopi/closed" => issues("closed"),
        
        # Closed issue
        "issues/show/fcoury/octopi/27" => issues("27"),
        # Open issue
        "issues/show/fcoury/octopi/28" => issues("28"),
        
        "repos/show/fcoury" => File.join("repos", "show", "fcoury"),
        "repos/show/fcoury/octopi" => repos("master"),
        "repos/show/fcoury/octopi/branches" => repos("branches"),
        "repos/show/fcoury/octopi/tags" => repos("tags"),
        
        "tree/show/fcoury/octopi/#{sha}" => File.join("tree", "fcoury", "octopi", sha),
        
        "user/show/fcoury" => File.join("users", "fcoury"),
        
        "user/show/fcoury/followers" => File.join("users/followers"),
        "user/show/fcoury/following" => File.join("users/following"),
        "user/search/radar" => File.join("users/search-radar"),
        
        
          }
        
  fakes.each do |key, value|
    FakeWeb.register_uri(:get, "http://#{yaml_api}/" + key, :response => stub_file(value))
  end
  
  ["augustl", "bcalloway", "danlucraft", "dcrec1", "derencius", "dustin", "elliottcable", "gwoliveira", "hashrocket", "jruby", "kchris", "paulorv", "remi", "shanesveller", "superfeedr", "taylorrf", "tgraham", "tmm1", "tpope", "webbynode"].each do |followee|
    FakeWeb.register_uri(:get, "http://#{yaml_api}/user/show/#{followee}", :response => stub_file("users/#{followee}") )
  end
  
  
  fake_posts = {
    "issues/label/add/fcoury/octopi/one-point-oh/28" => issues("labels", "28-one-point-oh"),
    "issues/label/add/fcoury/octopi/maybe-two-point-oh/28" => issues("labels", "28-maybe-two-point-oh"),
    "issues/label/remove/fcoury/octopi/one-point-oh/28" => issues("labels", "28-remove-one-point-oh"),
    "issues/label/remove/fcoury/octopi/maybe-two-point-oh/28" => issues("labels", "28-remove-maybe-two-point-oh"),
    "issues/reopen/fcoury/octopi/27" => issues("27-reopened"),
    "issues/open/fcoury/octopi" => issues("new"),
    "issues/close/fcoury/octopi/28" => issues("28-closed"),
    "issues/edit/fcoury/octopi/28" => issues("28-edited"), 
    "issues/reopen/fcoury/octopi/27" => issues("27-reopened"),        
    "issues/comment/fcoury/octopi/28" => issues("comment", "28-comment"),
  }.each do |key, value|
    FakeWeb.register_uri(:post, "http://#{yaml_api}/" + key, :response => stub_file(value))
  end
  
  # # rboard is a private repository
  FakeWeb.register_uri(:get, "http://#{yaml_api}/repos/show/fcoury/rboard", :response => stub_file("errors", "repository", "not_found"))
  
  # nothere is obviously an invalid sha
  FakeWeb.register_uri(:get, "http://#{yaml_api}/commits/show/fcoury/octopi/nothere", :status => ["404", "Not Found"])
  # not-a-number is obviously not a *number*
  FakeWeb.register_uri(:get, "http://#{yaml_api}/issues/show/fcoury/octopi/not-a-number", :status => ["404", "Not Found"])
  # is an invalid hash
  FakeWeb.register_uri(:get, "http://#{yaml_api}/tree/show/fcoury/octopi/#{fake_sha}", :status => ["404", "Not Found"])
  # is not a user
  FakeWeb.register_uri(:get, "http://#{yaml_api}/user/show/i-am-most-probably-a-user-that-does-not-exist", :status => ["404", "Not Found"])
  
  
  FakeWeb.register_uri(:get, "http://github.com/login", :response => stub_file("login"))
  FakeWeb.register_uri(:post, "http://github.com/session", :response => stub_file("dashboard"))
  FakeWeb.register_uri(:get, "http://github.com/account", :response => stub_file("account"))
  
  # Personal & Private stuff
  
  secure_fakes = {
    
    "commits/list/fcoury/rboard/master" => File.join("commits", "fcoury", "rboard", "master"),
     
    "repos/show/fcoury" => File.join("repos", "show", "fcoury-private"),
    "repos/show/fcoury/octopi" => File.join("repos", "fcoury", "octopi", "master"),
    "repos/show/fcoury/rboard" => File.join("repos", "fcoury", "rboard", "master"),
    
    "user/keys" => File.join("users", "keys"),
    "user/show/fcoury" => File.join("users", "fcoury-private")
  }
  
  secure_fakes.each do |key, value|
    FakeWeb.register_uri(:get, "https://#{yaml_api}/" + key, :response => stub_file(value))
  end
  
  secure_post_fakes = { 
    "user/key/add" => File.join("users", "key-added"),
    "user/key/remove" => File.join("users", "key-removed")
    }
    
  secure_post_fakes.each do |key, value|
    FakeWeb.register_uri(:post, "https://#{yaml_api}/" + key, :response => stub_file(value))
  end
    
  
  # And the plain fakes
  FakeWeb.register_uri(:get, "http://#{plain_api}/blob/show/fcoury/octopi/#{sha}", 
  :response => stub_file(File.join("blob", "fcoury", "octopi", "plain", sha)))
  
  
  FakeWeb.register_uri(:get, "http://github.com/fcoury/octopi/comments.atom", :response => stub_file("comments", "fcoury", "octopi", "comments.atom"))
end


class Test::Unit::TestCase
  
end
