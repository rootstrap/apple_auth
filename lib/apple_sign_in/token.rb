# frozen_string_literal: true

module AppleSignIn
  class Token
    APPLE_AUD = 'https://appleid.apple.com'
    APPLE_TOKEN_URL = 'https://appleid.apple.com/auth/token'
    APPLE_CONFIG = AppleSignIn.config
    APPLE_CODE_TYPE = 'authorization_code'
    APPLE_ALG = 'ES256'

    attr_reader :grant_type, :code, :refresh_token

    def initialize(type, code, refresh_token)
      @grant_type = type
      @code = code
      @refresh_token = refresh_token
    end

    # :reek:FeatureEnvy
    def authenticate
      uri = URI.parse(APPLE_TOKEN_URL)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri, request_header)
      request.body = apple_token_params.to_json
      http.request(request)
    end

    def apple_token_params
      params = {
        client_id: APPLE_CONFIG.apple_team_id,
        client_secret: client_secret_from_jwt,
        grant_type: grant_type,
        redirect_uri: APPLE_CONFIG.redirect_uri
      }
      if grant_type == APPLE_CODE_TYPE
        params.merge({
                       code: code
                     })
      else
        params.merge({
                       refresh_token: refresh_token
                     })
      end
    end

    def client_secret_from_jwt
      JWT.encode(claims, gen_private_key, APPLE_ALG, claims_headers)
    end

    def claims
      time_now = Time.now.to_i
      {
        iss: APPLE_CONFIG.apple_team_id,
        iat: time_now,
        exp: time_now + 10.minutes.to_i,
        aud: APPLE_AUD,
        sub: APPLE_CONFIG.apple_client_id
      }
    end

    def claims_headers
      {
        alg: APPLE_ALG,
        kid: AppleSignIn.config.apple_key_id
      }
    end

    def request_header
      {
        'Content-Type': 'application/x-www-form-urlencoded'
      }
    end

    def gen_private_key
      key = AppleSignIn.config.apple_private_key
      key = OpenSSL::PKey::EC.new(key) unless key.class == OpenSSL::PKey::EC
      key
    end
  end
end
