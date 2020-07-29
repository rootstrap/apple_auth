# frozen_string_literal: true

RSpec.describe AppleAuth::Generators::AppleSignInControllerGenerator, type: :generator do
  destination File.expand_path('tmp', __dir__)

  before do
    prepare_destination
  end

  it 'creates the controller file' do
    run_generator

    expect(File).to exist('spec/generators/tmp/app/controllers/apple_sign_in_controller.rb')
  end
end
