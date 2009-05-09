# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{octopi}
  s.version = "0.0.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.add_dependency('httparty', '>= 0.4')
  s.authors = ["Felipe Coury"]
  s.date = %q{2009-04-27}
  s.email = %q{felipe.coury@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "LICENSE"]
  s.files = ["README.rdoc", "VERSION.yml", "lib/octopi", "lib/octopi/base.rb", "lib/octopi/blob.rb", "lib/octopi/branch.rb", "lib/octopi/commit.rb", "lib/octopi/error.rb", "lib/octopi/file_object.rb", "lib/octopi/issue.rb", "lib/octopi/key.rb", "lib/octopi/repository.rb", "lib/octopi/resource.rb", "lib/octopi/tag.rb", "lib/octopi/user.rb", "lib/octopi.rb", "test/octopi_test.rb", "test/test_helper.rb", "LICENSE"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/fcoury/octopi}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{octopi}
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{A Ruby interface to GitHub API v2}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
