$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'oauth/cli/twitter'

access_token = OAuth::CLI::Twitter.get_access_token(:pit => 'oauth-cli-twitter-simple')
access_token.post(
  'http://twitter.com/statuses/update.json',
  'status'=> 'hello from ruby-oauth-cli-twitter simple example'
)
