# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AppleAuth::JWTConditions do
  let(:user_identity) { '1234.5678.910' }
  let(:jwt_sub) { user_identity }
  let(:jwt_iss) { 'https://appleid.apple.com' }
  let(:jwt_aud) { 'com.apple_auth' }
  let(:jwt_iat) { Time.now.to_i }
  let(:jwt_exp) { (jwt_iat + 5.minutes).to_i }
  let(:jwt) do
    {
      iss: jwt_iss,
      aud: jwt_aud,
      exp: jwt_exp,
      iat: jwt_iat,
      sub: jwt_sub,
      email: 'timmy@test.com',
      email_verified: 'true',
      is_private_email: 'false'
    }
  end

  let(:decoded_jwt) { ActiveSupport::HashWithIndifferentAccess.new(jwt) }

  before do
    AppleAuth.config.apple_client_id = 'com.apple_auth'
  end

  subject(:jwt_conditions_helper) { described_class.new(user_identity, decoded_jwt) }

  context '#valid?' do
    context 'when decoded jwt attributes are valid and user_identity is valid' do
      it 'returns true' do
        expect(jwt_conditions_helper.validate!).to eq(true)
      end
    end

    context 'when jwt has incorrect type attributes' do
      context 'when exp is not a integer' do
        let(:jwt_exp) { "Invalid" } # Dates are now valid on JWT library

        it 'raises an exception' do
          expect { jwt_conditions_helper.validate! }.to raise_error(
            AppleAuth::Conditions::JWTValidationError
          )
        end
      end

      context 'when iat is not a integer' do
        let(:jwt_iat) { Time.now }

        it 'raises an exception' do
          expect { jwt_conditions_helper.validate! }.to raise_error(
            AppleAuth::Conditions::JWTValidationError
          )
        end
      end
    end

    context 'when jwt sub is different to user_identity' do
      let(:jwt_sub) { '1234.5678.911' }

      it 'raises an exception' do
        expect { jwt_conditions_helper.validate! }.to raise_error(
          AppleAuth::Conditions::JWTValidationError
        )
      end
    end

    context 'when jwt aud is different to apple_client_id' do
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

    context 'when jwt_exp is leasser than now' do
      let(:jwt_exp) { Time.now.to_i }

      it 'raises an exception' do
        expect { jwt_conditions_helper.validate! }.to raise_error(
          AppleAuth::Conditions::JWTValidationError, 'Signature has expired'
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
