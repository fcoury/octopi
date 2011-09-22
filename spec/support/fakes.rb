require 'webmock/rspec'

module Fakes
  def api_stub(route)
    stub_request(:get, "https://api.github.com/" + route).to_return(fake(route))
  end

  private

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
end

RSpec.configure do |config|
  config.include Fakes
  config.before(:each) do
    api_stub("gists/1115247")
    api_stub("orgs/carlhuda/repos")

    api_stub("users/fcoury")
    api_stub("users/fcoury/gists")
    api_stub("users/rails3book/repos")
  end
end