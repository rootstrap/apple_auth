# frozen_string_literal: true

module AppleAuth
  class Token
    APPLE_AUD = 'https://appleid.apple.com'
    APPLE_CONFIG = AppleAuth.config
    APPLE_CODE_TYPE = 'authorization_code'
    APPLE_ALG = 'ES256'

    def initialize(code)
      @code = code
    end

    # :reek:FeatureEnvy
    def authenticate!
      access_token = apple_access_token
      access_token.refresh! if access_token.expired?

      reponse_hash(access_token)
    end

    private

    attr_reader :code

    def apple_token_params
      {
        client_id: APPLE_CONFIG.apple_team_id,
        client_secret: client_secret_from_jwt,
        grant_type: APPLE_CODE_TYPE,
        redirect_uri: APPLE_CONFIG.redirect_uri,
        code: code
      }
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
        kid: AppleAuth.config.apple_key_id
      }
    end

    def request_header
      {
        'Content-Type': 'application/x-www-form-urlencoded'
      }
    end

    def gen_private_key
      key = AppleAuth.config.apple_private_key
      key = OpenSSL::PKey::EC.new(key) unless key.instance_of?(OpenSSL::PKey::EC)
      key
    end

    def client_urls
      {
        site: APPLE_AUD,
        authorize_url: '/auth/authorize',
        token_url: '/auth/token'
      }
    end

    # Apple seems to expect the auth_scheme to be on
    # the body, the default is :basic_auth
    def auth_scheme
      {
        auth_scheme: :request_body
      }
    end

    def oauth_options
      client_urls.merge(auth_scheme)
    end

    def reponse_hash(access_token)
      token_hash = { access_token: access_token.token }

      expires = access_token.expires?
      if expires
        token_hash[:expires_at] = access_token.expires_at
        refresh_token = access_token.refresh_token
        token_hash[:refresh_token] = refresh_token if refresh_token
      end

      token_hash
    end

    def apple_access_token
      client = ::OAuth2::Client.new(APPLE_CONFIG.apple_client_id,
                                    client_secret_from_jwt,
                                    oauth_options)
      client.auth_code.get_token(code, { redirect_uri: APPLE_CONFIG.redirect_uri }, {})
    end
  end
end
