require 'yaml'
require 'ostruct'
require 'rubygems'
require 'oauth/cli'
require 'readline' # for requiring 'termtter/system_extensions'
require 'termtter/system_extensions' # for open_browser() method

module OAuth
  class CLI
    class Twitter
  
      def self.get_access_token(consumer_token, consumer_secret, options)
        new(consumer_token, consumer_secret).get_access_token(options)
      end

      def initialize(consumer_token, consumer_secret)
        @consumer_token, @consumer_secret = consumer_token, consumer_secret
      end
  
      def get_access_token(options)
        raise ArgumentError unless options.is_a?(Hash)
        if File.exist?(options[:save_to])
          load_from_file(options[:save_to])
        else
          access_token = authorize(options[:open_browser])
          save_to_file(access_token, options[:save_to]) if options[:save_to]
          OpenStruct.new({
              :token => access_token.params[:oauth_token],
              :secret => access_token.params[:oauth_token_secret],
              :user_id => access_token.params[:user_id],
              :screen_name => access_token.params[:screen_name]
          })
        end
      end
  
      def load_from_file(file)
        OpenStruct.new(YAML.load(File.read(file)))
      end
  
      def save_to_file(access_token, file)
        File.open(file, 'w') do |f|
          h = {:token => access_token.token, :secret => access_token.secret}
          f.write(h.to_yaml)
        end 
      end
  
      def authorize(open_browser)
        consumer = OAuth::Consumer.new(
          @consumer_token,
          @consumer_secret,
          :site => 'http://api.twitter.com',
          :proxy => ENV['http_proxy']
        )
        request_token = consumer.get_request_token
        url = request_token.authorize_url
        pin = ''
        if open_browser
          open_browser(url)
          pin = prompt_for_pin
        else
          puts 'Go to URL below to allow this application.'
          puts url
          pin = prompt_for_pin
        end
        request_token.get_access_token(:oauth_verifier => pin)
      end
  
      def prompt_for_pin
        pin = ''
        until pin =~ /^\d+$/
          print 'Enter pin > '
          pin = STDIN.gets.chomp
        end
        pin
      end
    end
  end
end
