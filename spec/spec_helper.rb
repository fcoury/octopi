require 'rspec'
require 'octopi'

SPEC_ROOT = File.dirname(__FILE__)

Dir[SPEC_ROOT + "/support/**/*.rb"].each { |f| require f }

