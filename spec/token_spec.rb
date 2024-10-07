# frozen_string_literal: true

RSpec.describe AppleAuth::Token do
  subject(:token_service) { described_class.new(code) }

  # ostruct is deprecated, so we use a Struct instead
  MockedData = Struct.new(:token, :expired?, :expires?, :refresh_token, :expires_at) do
    def refresh!
      self
    end
  end

  context '#authenticate!' do
    context 'when parameters are valid' do
      let(:code) { 'valid_code' }

      before do
        AppleAuth.config.apple_client_id = 'client_id'
        AppleAuth.config.apple_private_key = OpenSSL::PKey::EC.generate('prime256v1')
        AppleAuth.config.apple_key_id = 'apple_kid'
        AppleAuth.config.apple_team_id = 'team_id'
        AppleAuth.config.redirect_uri = 'www.example.com'
      end

      context 'when the access token is not expired' do
        before do
          mocked_data = MockedData.new('1234', false)
          allow(token_service).to receive(:apple_access_token).and_return(mocked_data)
        end

        it 'returns a hash with the corresponding access_token and expired value' do
          expect(token_service.authenticate!).to include({ access_token: '1234' })
        end
      end

      context 'when the access token is expired' do
        before do
          mocked_data = MockedData.new(nil, true, true, '4321', 1_594_667_034)
          allow(token_service).to receive(:apple_access_token).and_return(mocked_data)
        end

        it 'returns a hash with the corresponding access_token and expired value' do
          expect(token_service.authenticate!).to include(
            {
              refresh_token: '4321',
              expires_at: 1_594_667_034,
              access_token: nil
            }
          )
        end
      end
    end
  end
end
