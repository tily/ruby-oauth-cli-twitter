$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'rubytter'
require 'oauth/cli/twitter'

CONSUMER_TOKEN  = '358RyJ77o4BYJUViVRQ'
CONSUMER_SECRET = 'aOHsTInoyOjNewpvC9c5uwBqF3XOd5xSGlHFtaB8A'

access_token = OAuth::CLI::Twitter.get_access_token(:pit => 'oauth-cli-twitter-dc')
rubytter = OAuthRubytter.new(access_token)
rubytter.update('hello from ruby-oauth-cli-twitter define constant example')

