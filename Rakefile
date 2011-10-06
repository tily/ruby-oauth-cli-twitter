require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "oauth-cli-twitter"
    gem.summary = %Q{Twitter OAuth Interface for CLI Applications}
    gem.description = %Q{Twitter OAuth Interface for CLI Applications}
    gem.email = "tily05@gmail.com"
    gem.homepage = "http://github.com/tily/ruby-oauth-cli-twitter"
    gem.authors = ["tily"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_dependency "oauth"
    gem.add_dependency "termtter"
    gem.add_dependency "pit"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ruby-oauth-cli-twitter #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
