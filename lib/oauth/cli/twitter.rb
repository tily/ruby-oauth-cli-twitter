
require 'rubygems'
require 'oauth'
require 'readline'
require 'termtter/system_extensions'
require 'pit'

module OAuth
  class CLI 
    module Twitter
      extend self
    
      CONSUMER_TOKEN = 'UWhf189fDdtCZz6rq8Q5gA'
      CONSUMER_SECRET = 'QQHee9yFJqWeztLvGRj5A552gCGIJ7N0yLtpsJPZeU'
    
      def self.included(includer)
        @includer = includer
      end
      attr_accessor :includer
    
      def get_access_token(*args)
        case args.size
        when 1
          @options = args[0]
          # TODO: add extender ?
          if Twitter.includer &&
             Twitter.includer.const_defined?(:CONSUMER_TOKEN) &&
             Twitter.includer.const_defined?(:CONSUMER_SECRET)
            @consumer_token  = Twitter.includer::CONSUMER_TOKEN
            @consumer_secret = Twitter.includer::CONSUMER_SECRET
          elsif Object.const_defined?(:CONSUMER_TOKEN) &&
                Object.const_defined?(:CONSUMER_SECRET)
            @consumer_token  = Object::CONSUMER_TOKEN
            @consumer_secret = Object::CONSUMER_SECRET
          else
            @consumer_token  = CONSUMER_TOKEN
            @consumer_secret = CONSUMER_SECRET
          end
        when 2, 3
          @consumer_token, @consumer_secret, @options = args
        else
          raise ArgumentError
        end
        execute
      end
    
      def execute
        config = load_config
        if config && config['oauth_token'] && config['oauth_token_secret']
          @access_token = OAuth::AccessToken.new(
            consumer,
            config['oauth_token'],
            config['oauth_token_secret']
          )
          @access_token.params = config
        else
          @access_token = authorize
          save_config(config)
        end
        @access_token
      end
    
      def load_config
        if @options[:pit]
          Pit.get(@options[:pit])
        elsif @options[:file] && File.exist?(@options[:file])
          YAML.load(File.read(@options[:file]))
        end
      end
    
      def save_config(config)
        config = {} if !config
        config.update(@access_token.params)
        if @options[:pit]
          Pit.set(@options[:pit], :data => config)
        elsif @options[:file]
          File.open(@options[:file], 'w') do |f|
            f.write(config.to_yaml)
          end
        end
      end
    
      def authorize
        if @options[:browser]
          Kernel.send(:open_browser, request_token.authorize_url)
        else
          STDOUT.puts 'Visit URL below to allow this application.'
          STDOUT.puts request_token.authorize_url
        end
        request_token.get_access_token(:oauth_verifier => prompt_pin)
      end
    
      def request_token
        @request_token ||= consumer.get_request_token
      end
    
      def consumer
        @consumer ||= OAuth::Consumer.new(
          @consumer_token,
          @consumer_secret,
          :site => 'http://api.twitter.com',
          :proxy => ENV['http_proxy']
        )
      end
      
      def prompt_pin
        while pin = Readline.readline('Enter pin > ')
          break pin if pin =~ /^\d+$/
        end
      end
    end
  end
end

