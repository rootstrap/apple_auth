# frozen_string_literal: false

module AppleAuth
  class JWTServerConditions
    include Conditions

    CONDITIONS = [
      AudCondition,
      IatCondition,
      IssCondition
    ].freeze

    attr_reader :decoded_jwt

    def initialize(decoded_jwt)
      @decoded_jwt = decoded_jwt
    end

    def validate!
      JWT::ClaimsValidator.new(decoded_jwt).validate! && jwt_conditions_validate!
    rescue JWT::InvalidPayload => e
      raise JWTValidationError, e.message
    end

    private

    def jwt_conditions_validate!
      conditions_results = CONDITIONS.map do |condition|
        condition.new(decoded_jwt).validate!
      end
      conditions_results.all? { |value| value == true }
    end
  end
end
