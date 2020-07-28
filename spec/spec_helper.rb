# frozen_string_literal: true

require 'rspec'
require 'action_controller/railtie'
require 'generator_spec'
require 'bundler/setup'
require 'simplecov'
require 'webmock/rspec'

require './lib/apple_auth'

SimpleCov.start do
  add_filter '/spec/'
end

require 'apple_auth/base'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
