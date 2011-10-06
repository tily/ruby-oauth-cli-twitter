require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe OAuth::CLI::Twitter do
  before do
    @klass = Class.new
    @klass.send(:include, OAuth::CLI::Twitter)
    @twitter = @klass.new
  end

  describe 'taking arguments' do
    before do
      @consumer_token = 'dummy consumer token'
      @consumer_secret = 'dummy consumer secret'
      @options = {}
      @access_token = 'dummy access token'
    end

    it '#get_access_token with 1 arg' do
      @twitter.should_receive(:execute).and_return(@access_token)
      @twitter.get_access_token(@options).should == @access_token
    end

    it '#get_access_token with 2 arg' do
      @twitter.should_receive(:execute).and_return(@access_token)
      @twitter.get_access_token(@consumer_token, @consumer_secret).should == @access_token
    end

    it '#get_access_token with 3 arg' do
      @twitter.should_receive(:execute).and_return(@access_token)
      @twitter.get_access_token(@consumer_token, @consumer_secret, @options).should == @access_token
    end

    it '#get_access_token with no arg (raise error)' do
      lambda { @twitter.get_access_token }.should raise_error ArgumentError
    end

    it '#get_access_token with 4 (raise error)' do
      lambda {
        @twitter.get_access_token(@consumer_token, @consumer_secret, @options, 'extra arg')
      }.should raise_error ArgumentError
    end
  end

  describe 'getting constants' do
    it '#get_access_token gets constants of itself' do
      @twitter.should_receive(:execute).and_return(@access_token)
      @twitter.get_access_token(@options)
      @twitter.instance_variable_get('@consumer_token').should == OAuth::CLI::Twitter::CONSUMER_TOKEN
      @twitter.instance_variable_get('@consumer_secret').should == OAuth::CLI::Twitter::CONSUMER_SECRET
    end

    it '#get_access_token gets constants of Object' do
      @twitter.should_receive(:execute).and_return(@access_token)
      @klass::CONSUMER_TOKEN = 'object consumer token'
      @klass::CONSUMER_SECRET = 'object consumer secret'
      @twitter.get_access_token(@options)
      @twitter.instance_variable_get('@consumer_token').should == @klass::CONSUMER_TOKEN
      @twitter.instance_variable_get('@consumer_secret').should == @klass::CONSUMER_SECRET
    end

    it '#get_access_token gets constants of includer' do
      @twitter.should_receive(:execute).and_return(@access_token)
      @klass = Class.new
      @klass::CONSUMER_TOKEN = 'includer consumer token'
      @klass::CONSUMER_SECRET = 'includer consumer secret'
      @klass.send(:include, OAuth::CLI::Twitter)
      @twitter.get_access_token(@options)
      @twitter.instance_variable_get('@consumer_token').should == @klass::CONSUMER_TOKEN
      @twitter.instance_variable_get('@consumer_secret').should == @klass::CONSUMER_SECRET
    end

    it '#get_access_token gets constants of extender' do
      @twitter.should_receive(:execute).and_return(@access_token)
      @obj = Class.new
      @obj::CONSUMER_TOKEN = 'extender consumer token'
      @obj::CONSUMER_SECRET = 'extender consumer secret'
      @obj.send(:extend, OAuth::CLI::Twitter)
      @twitter.get_access_token(@options)
      @twitter.instance_variable_get('@consumer_token').should == @obj::CONSUMER_TOKEN
      @twitter.instance_variable_get('@consumer_secret').should == @obj::CONSUMER_SECRET
    end
  end

  describe 'execution' do
    before do
      @access_token = 'dummy access token'
    end

    it '#execute and config loaded' do
      config = {'oauth_token' => 'dummy oauth token', 'oauth_token_secret' => 'dummy oauth token secret'}
      consumer = 'dummy consumer'
      @access_token.should_receive(:params=).with(config)
      @twitter.should_receive(:load_config).and_return(config)
      @twitter.should_receive(:consumer).and_return(consumer)
      OAuth::AccessToken.should_receive(:new).with(consumer, config['oauth_token'], config['oauth_token_secret']).and_return(@access_token)
      @twitter.execute.should == @access_token
    end

    it '#execute and config not loaded' do
      config = {}
      @twitter.should_receive(:load_config).and_return(config)
      @twitter.should_receive(:authorize).and_return(@access_token)
      @twitter.should_receive(:save_config).with(@access_token)
      @twitter.execute.should == @access_token
    end
  end
  
  describe 'loading config' do
    before do
      @config = 'dummy config'
    end

    it '#load_config from pit' do
      pit = 'pit key'

      Pit.should_receive(:get).with(pit).and_return(@config)

      @twitter.instance_variable_set('@options', {:pit => pit})
      @twitter.load_config.should == @config
    end

    it '#load_config from file' do
      file = '/path/to/.conf'
      yaml = '- dummy yaml'

      File.should_receive(:exist?).with(file).and_return(true)
      File.should_receive(:read).with(file).and_return(yaml)
      YAML.should_receive(:load).with(yaml).and_return(@config)

      @twitter.instance_variable_set('@options', {:file => file})
      @twitter.load_config.should == @config
    end
  end

  describe 'saving config' do
    before do
      @config = {'string_key' => 'value', :symbol_key => :value}
      @access_token = mock.tap {|m| m.should_receive(:params).and_return(@config) }
      @twitter.instance_variable_set('@access_token', @access_token)
    end

    it '#save_config to pit' do
      pit = 'pit key'
      data = {'string_key' => 'value'}

      Pit.should_receive(:set).with(pit, :data => data) 

      @twitter.instance_variable_set('@options', {:pit => pit})
    end

    it '#save_config to file' do
      file = '/path/to/.conf'
      yaml = "--- \nstring_key: value\n"

      File.should_receive(:open).with(file, 'w').and_yield(
        mock.tap {|m| m.should_receive(:write).with(yaml) }
      )

      @twitter.instance_variable_set('@options', {:file => file})
    end

    after do
      @twitter.save_config(@access_token)
    end
  end

  describe 'authorization' do
    before do
      @url, @pin = 'dummy url', '123456'
      @twitter.should_receive(:prompt_pin).and_return(@pin)
      @request_token = mock()
      @request_token.should_receive(:authorize_url).and_return(@url)
      @request_token.should_receive(:get_access_token).with(:oauth_verifier => @pin).and_return(@url)
      @twitter.should_receive(:request_token).twice.and_return(@request_token)
    end

    it '#authorize without browser' do
      STDOUT.should_receive(:puts).with('Visit URL below to allow this application.')
      STDOUT.should_receive(:puts).with(@url)

      @twitter.instance_variable_set('@options', {})
    end

    it '#authorize with browser' do
      Kernel.should_receive(:open_browser).with(@url)

      @twitter.instance_variable_set('@options', {:browser => true})
    end

    after do
      @twitter.authorize
    end
  end

  describe 'prompting' do
    it '#prompt_pin' do
      expect = '1234567'
      Readline.should_receive(:readline).once.with('Enter pin > ').and_return("not number")
      Readline.should_receive(:readline).once.with('Enter pin > ').and_return("#{expect}")
      @twitter.prompt_pin.should == expect
    end
  end

  describe 'OAuth wrapper methods' do
    it '#request_token' do
      expect = 'dummy request token'
      @twitter.should_receive(:consumer).once.and_return(
        mock.tap {|m| m.should_receive(:get_request_token).once.and_return(expect) }
      )
      2.times { @twitter.request_token.should == expect }
    end

    it '#consumer' do
      consumer = 'dummy consumer'
      OAuth::Consumer.should_receive(:new).once.with(
        @consumer_token,
        @consumer_secret,
        :site => 'http://api.twitter.com',
        :proxy => ENV['http_proxy']
      ).and_return(consumer)
      @twitter.instance_variable_set('@consumer_token', @consumer_token)
      @twitter.instance_variable_set('@consumer_secret', @consumer_secret)
      2.times { @twitter.consumer.should == consumer }
    end
  end
end
