require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'fakeweb'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'octopi'

def stub_file(*path)
  File.join(File.dirname(__FILE__), "stubs", path)
end

def fake_everything
  yaml_api = "github.com/api/v2/yaml"
  plain_api = "github.com:80/api/v2/plain"
  # Set this to true or comment out if you want to test against real data
  # Which, in a theoretical world should Just Work (tm)
  # This is of course with the exception of the authenticated tests
  FakeWeb.allow_net_connect = false
  
  # Public stuff
  fakes = { 
        "user/show/fcoury" => File.join("users", "fcoury"),
        
        "repos/show/fcoury/octopi" => File.join("repos", "fcoury", "octopi", "main"),
        "repos/show/fcoury/octopi/branches" => File.join("repos", "fcoury", "octopi", "branches"),
        
        "issues/list/fcoury/octopi/open" => File.join("issues", "fcoury", "octopi", "open"),
        "issues/show/fcoury/octopi/28" => File.join("issues", "fcoury", "octopi", "28"),
        
        "commits/list/fcoury/octopi/master" => File.join("commits", "fcoury", "octopi", "master"),
        "commits/list/fcoury/octopi/lazy" => File.join("commits", "fcoury", "octopi", "lazy"),
        
        "repos/show/fcoury" => File.join("repos", "show", "fcoury")
          }
  
  fakes.each do |key, value|
    FakeWeb.register_uri("http://#{yaml_api}/" + key, :string => YAML::load_file(stub_file(value)))
  end
  
  # rboard is a private repository
  FakeWeb.register_uri("http://#{yaml_api}/repos/show/fcoury/rboard", :string => YAML::load_file(stub_file("errors", "repository", "not_found")))
  
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
  sha = "f6609209c3ac0badd004512d318bfaa508ea10ae"
  FakeWeb.register_uri("http://#{plain_api}/blob/show/fcoury/octopi/#{sha}", 
  :string => File.read(stub_file(File.join("blob", "fcoury", "octopi", "plain", sha))))
end

def assert_find_all(cls, check_method, repo, user)
  repo_method = cls.resource_name(:plural)

  item1 = cls.find_all(repo.name,user.login).first
  item2 = cls.find_all(repo).first
  item3 = repo.send(repo_method).first
  
  assert_equal item1.send(check_method), item2.send(check_method)
  assert_equal item1.send(check_method), item3.send(check_method)
end


class Test::Unit::TestCase
  
end
