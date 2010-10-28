$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'oauth/cli/twitter'

access_token = OAuth::CLI::Twitter.get_access_token(
  '358RyJ77o4BYJUViVRQ', 'aOHsTInoyOjNewpvC9c5uwBqF3XOd5xSGlHFtaB8A',
  :save_to => ENV['HOME'] + '/.oauthclitwitter'
)
puts access_token.token, access_token.secret, access_token.user_id, access_token.screen_name

