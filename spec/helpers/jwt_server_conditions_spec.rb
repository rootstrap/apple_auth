# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AppleAuth::JWTServerConditions do
  let(:jwt_sub) { '820417.faa325acbc78e1be1668ba852d492d8a.0219' }
  let(:jwt_iss) { 'https://appleid.apple.com' }
  let(:jwt_aud) { 'com.apple_auth' }
  let(:jwt_iat) { Time.now.to_i }
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

  let(:decoded_jwt) { ActiveSupport::HashWithIndifferentAccess.new(jwt) }

  before do
    AppleAuth.config.apple_client_id = 'com.apple_auth'
  end

  subject(:jwt_conditions_helper) { described_class.new(decoded_jwt) }

  context '#valid?' do
    context 'when decoded jwt attributes are valid' do
      it 'returns true' do
        expect(jwt_conditions_helper.validate!).to eq(true)
      end
    end

    context 'when jwt has incorrect type attributes' do
      context 'when iat is not a integer' do
        let(:jwt_iat) { Time.now }

        it 'raises an exception' do
          expect { jwt_conditions_helper.validate! }.to raise_error(
            AppleAuth::Conditions::JWTValidationError
          )
        end
      end
    end

    context 'when jwt_aud is different to apple_client_id' do
      let(:jwt_aud) { 'net.apple_auth' }

      it 'raises an exception' do
        expect { jwt_conditions_helper.validate! }.to raise_error(
          AppleAuth::Conditions::JWTValidationError, 'jwt_aud is different to apple_client_id'
        )
      end
    end

    context 'when jwt_iss is different to apple_iss' do
      let(:jwt_iss) { 'https://appleid.apple.net' }

      it 'raises an exception' do
        expect { jwt_conditions_helper.validate! }.to raise_error(
          AppleAuth::Conditions::JWTValidationError, 'jwt_iss is different to apple_iss'
        )
      end
    end

    context 'when jwt_iat is greater than now' do
      let(:jwt_iat) { (Time.now + 5.minutes).to_i }

      it 'raises an exception' do
        expect { jwt_conditions_helper.validate! }.to raise_error(
          AppleAuth::Conditions::JWTValidationError, 'Invalid iat'
        )
      end
    end
  end
end
