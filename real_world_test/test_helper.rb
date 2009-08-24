# These are the real world tests using real world data.
# Whilst the tests are good for ensuring Nothing Goes Wrong,
# It isn't good to always use fake data because you're fooling yourself.
# This test data uses my own personal ~/.gitconfig and will probably not work for you.
require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'octopi'
