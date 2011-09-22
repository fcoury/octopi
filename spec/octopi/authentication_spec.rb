require 'spec_helper'

describe "authentication" do
  it "authenticates successfully" do
    stub_successful_login!
    Octopi.authenticate!(:username => "radar", :password => "password").should be_true
  end
end