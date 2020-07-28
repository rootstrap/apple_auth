# frozen_string_literal: true

module AppleAuth
  module Conditions
    class IssCondition
      APPLE_ISS = 'https://appleid.apple.com'

      def initialize(jwt)
        @iss = jwt['iss']
      end

      def validate!
        return true if @iss.include?(APPLE_ISS)

        raise JWTValidationError, 'jwt_iss is different to apple_iss'
      end
    end
  end
end
