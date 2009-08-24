require 'lib/octopi'
include Octopi
authenticated_with :token => "ba7bf2d7f0edc07373873dda887b18ae", :login => "radar" do
  User.find("radar")
end