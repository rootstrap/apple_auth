# frozen_string_literal: true

module AppleAuth
  class ServerIdentity
    attr_reader :jwt

    def initialize(jwt)
      @jwt = jwt
    end

    def validate!
      token_data = JWTDecoder.new(jwt).call

      JWTServerConditions.new(token_data).validate!

      token_data.symbolize_keys
    end
  end
end
