# frozen_string_literal: false

module AppleAuth
  class JWTDecoder
    APPLE_KEY_URL = 'https://appleid.apple.com/auth/keys'.freeze

    attr_reader :jwt

    def initialize(jwt)
      @jwt = jwt
    end

    def call
      decoded.first
    end

    private

    def decoded
      key_hash = apple_key_hash(jwt)
      apple_jwk = JWT::JWK.import(key_hash)
      JWT.decode(jwt, apple_jwk.public_key, true, algorithm: key_hash['alg'])
    end

    def apple_key_hash(jwt)
      response = Net::HTTP.get(URI.parse(APPLE_KEY_URL))
      certificate = JSON.parse(response)
      matching_key = certificate['keys'].select { |key| key['kid'] == jwt_kid(jwt) }
      ActiveSupport::HashWithIndifferentAccess.new(matching_key.first)
    end

    def jwt_kid(jwt)
      header = JSON.parse(Base64.decode64(jwt.split('.').first))
      header['kid']
    end
  end
end
