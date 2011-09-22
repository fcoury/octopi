# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "octopi/version"

Gem::Specification.new do |s|
  s.name        = "octopi"
  s.version     = Octopi::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Felipe Coury", "Ryan Bigg"]
  s.email       = ["felipe.coury@gmail.com", "radarlistener@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{A Ruby interface to GitHub API v3}
  s.description = %q{A Ruby interface to GitHub API v3}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
  
  s.add_dependency "httparty", "~> 0.4"
  s.add_dependency "json"
  s.add_development_dependency "rspec", "~> 2.6"
  s.add_development_dependency "webmock"
end
