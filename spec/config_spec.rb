# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AppleSignIn do
  let(:apple_client_id) { 'mocked_client_id' }
  let(:apple_private_key) { 'mocked_private_key' }
  let(:apple_key_id) { 'mocked_key_id' }
  let(:apple_team_id) { 'mocked_team_id' }
  let(:redirect_uri) { 'https://example.com/redirect_uri' }

  def configure_apple_variables
    AppleSignIn.configure do |config|
      config.apple_client_id = apple_client_id
      config.apple_private_key = apple_private_key
      config.apple_key_id = apple_key_id
      config.apple_team_id = apple_team_id
      config.redirect_uri = redirect_uri
    end
  end

  describe '.configure' do
    it 'adds the configuration to the module' do
      configure_apple_variables

      expect(AppleSignIn.config.apple_client_id).to eq apple_client_id
      expect(AppleSignIn.config.apple_private_key).to eq apple_private_key
      expect(AppleSignIn.config.apple_key_id).to eq apple_key_id
      expect(AppleSignIn.config.apple_team_id).to eq apple_team_id
      expect(AppleSignIn.config.redirect_uri).to eq redirect_uri
    end
  end

  describe '.reset_configuration' do
    before do
      configure_apple_variables
    end

    it 'resets all the configuration of the module' do
      AppleSignIn.reset_configuration

      expect(AppleSignIn.config.apple_client_id).not_to be_present
      expect(AppleSignIn.config.apple_private_key).not_to be_present
      expect(AppleSignIn.config.apple_key_id).not_to be_present
      expect(AppleSignIn.config.apple_team_id).not_to be_present
      expect(AppleSignIn.config.redirect_uri).not_to be_present
    end
  end
end
