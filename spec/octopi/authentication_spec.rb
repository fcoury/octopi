require 'spec_helper'

describe "authentication" do
  it "authenticates successfully" do
    Octopi.authenticate!(:username => "radar", :password => "password").should be_true
  end
end