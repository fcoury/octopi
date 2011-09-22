require 'webmock/rspec'

module Fakes
  def api_stub(route)
    stub_request(:get, "https://api.github.com/" + route).to_return(fake(route)) 
  end

  private

  def fake(route)
    File.read(SPEC_ROOT + "/fixtures/#{route}")
  end
end

RSpec.configure do |config|
  config.include Fakes
  config.before(:each) do
    api_stub("users/rails3book/repos")
    api_stub("orgs/carlhuda/repos")
  end
end