require 'rubygems'
require 'rake'
require 'bundler'

Bundler::GemHelper.install_tasks

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.libs << File.dirname(__FILE__)
  test.pattern = 'test/**/*_test.rb'
  test.verbose = false
end

task :default => :test
