# frozen_string_literal: false

require 'byebug'

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

    def valid?
      JWT::ClaimsValidator.new(decoded_jwt).validate! && valid_sub? && jwt_conditions_valid?
    rescue JWT::InvalidPayload
      false
    end

    private

    def valid_sub?
      user_identity && user_identity == decoded_jwt['sub']
    end

    def jwt_conditions_valid?
      conditions_results = CONDITIONS.map do |condition|
        condition.new(decoded_jwt).valid?
      end
      conditions_results.all? { |value| value == true }
    end
  end
end
