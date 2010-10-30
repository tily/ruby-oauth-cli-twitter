$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'twitter'
require 'oauth/cli/twitter'

class MyApplication
  include OAuth::CLI::Twitter

  CONSUMER_TOKEN  = '358RyJ77o4BYJUViVRQ'
  CONSUMER_SECRET = 'aOHsTInoyOjNewpvC9c5uwBqF3XOd5xSGlHFtaB8A'

  def initialize
    access_token = get_access_token(:pit => 'oauth-cli-twitter-inclusion')
    oauth = Twitter::OAuth.new(CONSUMER_TOKEN, CONSUMER_SECRET)
    oauth.authorize_from_access(access_token.token, access_token.secret)
    @twitter = Twitter::Base.new(oauth)
  end

  def update(status)
    @twitter.update(status)
  end
end

app = MyApplication.new
app.update('hello from ruby-oauth-cli-twitter inclusion example')
