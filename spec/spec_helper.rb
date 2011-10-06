$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'oauth/cli/twitter'
require 'rspec'
require 'rspec/autorun'
