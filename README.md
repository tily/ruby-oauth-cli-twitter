OAuth::CLI::Twitter
===================

Description
-----------

Twitter OAuth interface for CLI applications.

Usage
-----

### Interface

 * simple

        require 'oauth/cli/twitter'
        
        access_token = OAuth::CLI::Twitter.get_access_token(:pit => 'oauth-cli-twitter-simple')
        access_token.post(
          'http://twitter.com/statuses/update.json',
          'status'=> 'hello from ruby-oauth-cli-twitter simple example'
        )

 * define constants

        require 'rubygems'
        require 'rubytter'
        require 'oauth/cli/twitter'
        
        CONSUMER_TOKEN  = '358RyJ77o4BYJUViVRQ'
        CONSUMER_SECRET = 'aOHsTInoyOjNewpvC9c5uwBqF3XOd5xSGlHFtaB8A'
        
        access_token = OAuth::CLI::Twitter.get_access_token(:pit => 'oauth-cli-twitter-dc')
        rubytter = OAuthRubytter.new(access_token)
        rubytter.update('hello from ruby-oauth-cli-twitter define constant example')

 * include

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

### Save Config

 * save config to file

        include OAuth::CLI::Twitter
        p get_acccess_token(:file => ENV['HOME'] + '/.my_app')

 * save config to pit

        include OAuth::CLI::Twitter
        p get_acccess_token(:pit => 'my_app')

Requirement
-----------

 * readline
 * oauth
 * termtter
 * [pit](http://rubygems.org/gems/pit)

Install
-------

### Archive Installation

        rake install

### Gem Installation

        gem install oauth-cli-twitter

Copyright
---------

Copyright (c) 2010 tily. See LICENSE for details.
