# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AppleAuth::ServerIdentity do
  let(:jwt_iss) { 'https://appleid.apple.com' }
  let(:jwt_aud) { 'com.apple_sign_in' }
  let(:jwt_iat) { Time.now.to_i }
  let(:private_key) { OpenSSL::PKey::RSA.generate(2048) }
  let(:jwk) { JWT::JWK.new(private_key) }
  let(:jwt) do
    {
      iss: jwt_iss,
      aud: jwt_aud,
      iat: jwt_iat,
      events: '{
        "type": "email-enabled",
        "sub": "820417.faa325acbc78e1be1668ba852d492d8a.0219",
        "email": "ep9ks2tnph@privaterelay.appleid.com",
        "is_private_email": "true",
        "event_time": 1508184845
      }'
    }
  end

  let(:signed_jwt) { JWT.encode(jwt, jwk.keypair, 'RS256', kid: jwk.kid) }
  let(:exported_private_key) { JWT::JWK::RSA.new(private_key).export.merge({ alg: 'RS256' }) }
  let(:apple_body) { [exported_private_key] }

  before do
    stub_request(:get, 'https://appleid.apple.com/auth/keys')
      .to_return(
        body: {
          keys: apple_body
        }.to_json,
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      )
    AppleAuth.config.apple_client_id = jwt_aud
  end

  subject(:server_identity_service) { described_class.new(signed_jwt) }

  context '#valid?' do
    context 'when the parameters of the initilizer are correct' do
      it 'returns the validated JWT attributes' do
        expect(server_identity_service.validate!).to eq(jwt)
      end

      context 'when there are more than one private keys' do
        let(:private_key_two) { OpenSSL::PKey::RSA.generate(2048) }
        let(:exported_private_key_two) do
          JWT::JWK::RSA.new(private_key).export.merge({ alg: 'RS256' })
        end

        it 'returns the validated JWT attributes' do
          expect(server_identity_service.validate!).to eq(jwt)
        end
      end
    end

    context 'when the parameters of the initilizer are not correct' do
      let(:jwt) do
        {
          iss: 'https://not-an-appleid.com',
          aud: jwt_aud,
          iat: jwt_iat
        }
      end

      it 'raises an exception' do
        expect { server_identity_service.validate! }.to raise_error(
          AppleAuth::Conditions::JWTValidationError
        )
      end
    end
  end
end
