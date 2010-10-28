OAuth::CLI::Twitter
====================================================

Description
-----------
Twitter OAuth interface for CLI applications.

Usage
-----

 * Normal Operation

        require 'oauth/cli/twitter'
        
        access_token = OAuth::CLI::Twitter.get_access_token(
          '358RyJ77o4BYJUViVRQ', 'aOHsTInoyOjNewpvC9c5uwBqF3XOd5xSGlHFtaB8A',
          :save_to => ENV['HOME'] + '/.oauthclitwitter'
        )
        puts access_token.token, access_token.secret, access_token.user_id, access_token.screen_name

        $ ruby example/get_access_token.rb
        Go to URL below to allow this application.
        http://api.twitter.com/oauth/authorize?oauth_token=3UQUEi92ao9fuveeZPaHhC3mOWvV8VamiMFsi8OFw
        Enter pin >

 * Open Browser

        require 'oauth/cli/twitter'
        
        access_token = OAuth::CLI::Twitter.get_access_token(
          '358RyJ77o4BYJUViVRQ', 'aOHsTInoyOjNewpvC9c5uwBqF3XOd5xSGlHFtaB8A',
          :save_to => ENV['HOME'] + '/.oauthclitwitter', :open_browser => true
        )
        puts access_token.token, access_token.secret, access_token.user_id, access_token.screen_name

        $ ruby example/get_access_token.rb
        # after opening authorize_url with browser for your platform ...
        Enter pin >

Requirement
-----------

 * oauth
 * termtter

Install
-------

Copyright
---------

Copyright (c) 2010 tily. See LICENSE for details.
