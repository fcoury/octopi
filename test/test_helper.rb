require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'fakeweb'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'octopi'

def stub_file(file)
  File.join(File.dirname(__FILE__), "stubs", file)
end

def fake_everything
  # Set this to true or comment out if you want to test against real data
  # Which, in a theoretical world should Just Work (tm)
  # FakeWeb.allow_net_connect = false
  
  # Public stuff
  fakes = { 
        "user/show/fcoury" => File.join("users", "fcoury"),
        "repos/show/fcoury/octopi" => File.join("repos", "fcoury", "octopi"),
        "issues/list/fcoury/octopi/open" => File.join("issues", "fcoury", "octopi", "open"),
        "issues/show/fcoury/octopi/28" => File.join("issues", "fcoury", "octopi", "28"),
        "commits/list/fcoury/octopi/master" => File.join("commits", "fcoury", "octopi", "master"),
        "repos/show/fcoury" => File.join("repos", "show", "fcoury")
          }
  
  fakes.each do |key, value|
    FakeWeb.register_uri("http://github.com/api/v2/yaml/" + key, :string => YAML::load_file(stub_file(value)))
  end
  
  # Personal & Private stuff
  
  secure_fakes = {
    "user/show/fcoury" => File.join("users", "fcoury-private"),
    "repos/show/fcoury" => File.join("repos", "show", "fcoury-private"),
    "repos/show/fcoury/octopi" => File.join("repos", "fcoury", "octopi")
  }
  
  secure_fakes.each do |key, value|
    FakeWeb.register_uri("https://github.com/api/v2/yaml/" + key, :string => YAML::load_file(stub_file(value)))
  end
  
  # And the plain fakes
  sha = "f6609209c3ac0badd004512d318bfaa508ea10ae"
  FakeWeb.register_uri("http://github.com:80/api/v2/plain/blob/show/fcoury/octopi/#{sha}", 
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
