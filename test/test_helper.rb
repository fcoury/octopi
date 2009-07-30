require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'fakeweb'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'octopi'


def fake_everything
  # Set this to true or comment out if you want to test against real data.
  FakeWeb.allow_net_connect = false
  fakes = { 
        "user/show/fcoury" => File.join("users", "fcoury"),
        "repos/show/fcoury/octopi" => File.join("repos", "fcoury", "octopi"),
        "issues/list/fcoury/octopi/open" => File.join("issues", "fcoury", "octopi", "open"),
        "issues/show/fcoury/octopi/28" => File.join("issues", "fcoury", "octopi", "28"),
        "commits/list/fcoury/octopi/master" => File.join("commits", "fcoury", "octopi", "master"),
        "repos/show/fcoury" => File.join("repos", "show", "fcoury")
          }
  
  fakes.each do |key, value|
    FakeWeb.register_uri("http://github.com/api/v2/yaml/" + key, :string => YAML::load_file(File.join(File.dirname(__FILE__), "stubs", value)))
  end
  
  secure_fakes = {
    "user/show/fcoury" => File.join("users", "fcoury-private"),
    "repos/show/fcoury" => File.join("repos", "show", "fcoury-private"),
    "repos/show/fcoury/octopi" => File.join("repos", "fcoury", "octopi")
  }
  
  secure_fakes.each do |key, value|
    FakeWeb.register_uri("https://github.com/api/v2/yaml/" + key, :string => YAML::load_file(File.join(File.dirname(__FILE__), "stubs", value)))
  end
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
