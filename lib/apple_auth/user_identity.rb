# frozen_string_literal: true

module AppleAuth
  class UserIdentity
    attr_reader :user_identity, :jwt

    def initialize(user_identity, jwt)
      @user_identity = user_identity
      @jwt = jwt
    end

    def validate!
      token_data = JWTDecoder.new(jwt).call

      JWTConditions.new(user_identity, token_data).validate!

      token_data.symbolize_keys
    end
  end
end
