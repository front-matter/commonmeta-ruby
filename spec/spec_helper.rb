# frozen_string_literal: true

require 'bundler/setup'
Bundler.setup

require 'simplecov'
require 'simplecov_json_formatter'
SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter
SimpleCov.start

require 'briard'
require 'maremma'
require 'rspec'
require 'rack/test'
require 'webmock/rspec'
require 'rspec/xsd'
require 'nokogiri'
require 'vcr'

RSpec.configure do |config|
  config.order = :random
  config.include RSpec::XSD
  config.include WebMock::API
  config.include Rack::Test::Methods
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    ARGV.replace []
  end

  config.before(:suite) do
    ::NameDetector = GenderDetector.new
  end
end

def fixture_path
  "#{File.expand_path('fixtures', __dir__)}/"
end

# This code was adapted from Thor, available under MIT-LICENSE
# Copyright (c) 2008 Yehuda Katz, Eric Hodel, et al.
def capture(stream)
  begin
    stream = stream.to_s
    eval "$#{stream} = StringIO.new"
    yield
    result = eval("$#{stream}").string
  ensure
    eval("$#{stream} = #{stream.upcase}")
  end

  result
end

def capture_stdout
  original_stdout = $stdout
  $stdout = fake = StringIO.new
  begin
    yield
  ensure
    $stdout = original_stdout
  end
  fake.string
end

def capture_stderr
  original_stderr = $stderr
  $stderr = fake = StringIO.new
  begin
    yield
  ensure
    $stderr = original_stderr
  end
  fake.string
end

# This code was adapted from Ruby on Rails, available under MIT-LICENSE
# Copyright (c) 2004-2013 David Heinemeier Hansson
def silence_warnings
  old_verbose = $VERBOSE
  $VERBOSE = nil
  yield
ensure
  $VERBOSE = old_verbose
end

alias silence capture

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.ignore_localhost = true
  c.default_cassette_options = { :record => :new_episodes }
  c.configure_rspec_metadata!
end
