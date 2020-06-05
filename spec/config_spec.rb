# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AppleSignIn do
  let(:apple_aud) { '111111' }

  def configure_apple_aud
    AppleSignIn.configure do |config|
      config.apple_aud = apple_aud
    end
  end

  describe '.configure' do
    it 'adds the configuration to the module' do
      configure_apple_aud

      expect(AppleSignIn.config.apple_aud).to eq apple_aud
    end
  end

  describe '.reset_configuration' do
    before do
      configure_apple_aud
    end

    it 'resets all the configuration of the module' do
      AppleSignIn.reset_configuration

      expect(AppleSignIn.config.apple_aud).not_to be_present
    end
  end
end
