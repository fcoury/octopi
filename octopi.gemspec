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
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency(%q<nokogiri>, [">= 1.3.1"])
  s.add_dependency(%q<httparty>, [">= 0.4.5"])
  s.add_dependency(%q<mechanize>, [">= 0.9.3"])
  s.add_dependency(%q<api_cache>, [">= 0"])
  s.add_development_dependency(%q<shoulda>, [">= 0"])
  s.add_development_dependency(%q<fakeweb>, [">= 0"])
end
