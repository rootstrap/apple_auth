# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AppleAuth::Generators::ConfigGenerator, type: :generator do
  destination File.expand_path('tmp', __dir__)

  it 'creates the config file' do
    run_generator

    expect(File).to exist('spec/generators/tmp/config/initializers/apple_auth.rb')
  end
end
