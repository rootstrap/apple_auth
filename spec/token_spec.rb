# frozen_string_literal: true

RSpec.describe AppleSignIn::Token do
  subject(:token_service) { described_class.new(code, grant_type, refresh_token) }

  context '#authenticate' do
    context 'when parameters are valid' do
      let(:code) { 'valid_code' }
      let(:grant_type) { 'valid_type' }
      let(:refresh_token) { 'valid_token' }

      before do
        stub_request(:post, 'http://appleid.apple.com:443/auth/token')
          .to_return(
            body: {
            }.to_json,
            status: 200,
            headers: { 'Content-Type': 'application/json' }
          )
        AppleSignIn.config.apple_client_id = 'client_id'
        AppleSignIn.config.apple_private_key = OpenSSL::PKey::EC.new('prime256v1').generate_key!
        AppleSignIn.config.apple_key_id = 'apple_kid'
        AppleSignIn.config.apple_team_id = 'team_id'
        AppleSignIn.config.redirect_uri = 'www.example.com'
      end

      it 'return a success response' do
        expect(token_service.authenticate.code).to eq('200')
      end
    end

    context 'when parameters are invalid' do
      let(:code) { 'invalid_code' }
      let(:grant_type) { 'invalid_type' }
      let(:refresh_token) { 'invalid_token' }

      before do
        stub_request(:post, 'http://appleid.apple.com:443/auth/token')
          .to_return(
            body: {
            }.to_json,
            status: 400,
            headers: { 'Content-Type': 'application/json' }
          )
        AppleSignIn.config.apple_client_id = 'invalid_client_id'
        AppleSignIn.config.apple_private_key = OpenSSL::PKey::EC.new('prime256v1').generate_key!
        AppleSignIn.config.apple_key_id = 'invalid_kid'
        AppleSignIn.config.apple_team_id = 'invalid_team_id'
        AppleSignIn.config.redirect_uri = 'www.example.com'
      end

      it 'returns a bad request' do
        expect(token_service.authenticate.code).to eq('400')
      end
    end
  end
end
