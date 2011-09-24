require 'webmock/rspec'

module Fakes
  def api_stub(route)
    stub_request(:get, base_url + route).to_return(fake(route))
  end
  
  def authenticated_api_stub(route, username="radar")
    stub_request(:get, authenticated_base_url(username) + route).to_return(fake(route))
  end

  private
  
  def base_url
    "https://api.github.com/"
  end
  
  def authenticated_base_url(username="radar")
    "https://#{username}:password@api.github.com/"
  end

  def fake(route)
    # TODO: maybe there's a better way of organising the files here?
    file = SPEC_ROOT + "/fixtures/#{route}"
    # Some files have a .json extension.
    # These are for routes without parameters
    if File.file?(file + ".json")
      return File.read(file + ".json")
    # For files with parameters, they have no .json extension
    elsif File.file?(file)
      return File.read(file)
    end
    raise("Could not find fake file: #{file}")
  end
  
  def stub_successful_login!(username="radar")
    stub_request(:get, "https://#{username}:password@api.github.com").to_return(:status => 302, :body => "")
  end
end

RSpec.configure do |config|
  config.include Fakes
  config.before(:each) do
    Octopi.logout!
    stub_successful_login!
  end
end