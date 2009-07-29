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
        "commits/list/fcoury/octopi/master" => File.join("commits", "fcoury", "octopi", "master")
          }
  
  fakes.each do |key, value|
    FakeWeb.register_uri("http://github.com:80/api/v2/yaml/" + key, :string => YAML::load_file(File.join(File.dirname(__FILE__), "stubs", value)))
  end
end

class Test::Unit::TestCase
end
