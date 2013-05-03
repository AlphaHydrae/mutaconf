require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rspec'
require 'fakefs/spec_helpers'
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each{ |f| require f }

RSpec.configure do |config|

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

require 'simplecov'
SimpleCov.start

require 'mutaconf'
