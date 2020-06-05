# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AppleSignIn::Generators::ConfigGenerator, type: :generator do
  destination File.expand_path('tmp', __dir__)

  before do
    prepare_destination
  end

  it 'creates the config file' do
    run_generator

    expect(File).to exist('spec/generators/tmp/config/initializers/apple_sign_in.rb')
  end
end
