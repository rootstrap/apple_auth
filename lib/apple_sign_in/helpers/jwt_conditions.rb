# frozen_string_literal: false

module AppleSignIn
  class JWTConditions
    include Conditions

    CONDITIONS = [
      AudCondition,
      ExpCondition,
      IatCondition,
      IssCondition
    ].freeze

    attr_reader :user_identity, :decoded_jwt

    def initialize(user_identity, decoded_jwt)
      @user_identity = user_identity
      @decoded_jwt = decoded_jwt
    end

    def validate!
      JWT::ClaimsValidator.new(decoded_jwt).validate! && validate_sub! && jwt_conditions_validate!
    rescue JWT::InvalidPayload => e
      raise JWTValidationError, e.message
    end

    private

    def validate_sub!
      return true if user_identity && user_identity == decoded_jwt['sub']

      raise JWTValidationError, 'Not valid Sub'
    end

    def jwt_conditions_validate!
      conditions_results = CONDITIONS.map do |condition|
        condition.new(decoded_jwt).validate!
      end
      conditions_results.all? { |value| value == true }
    end
  end
end
