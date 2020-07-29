# frozen_string_literal: true

module AppleAuth
  module Conditions
    class ExpCondition
      def initialize(jwt)
        @exp = jwt['exp'].to_i
      end

      def validate!
        return true if @exp > Time.now.to_i

        raise JWTValidationError, 'Expired jwt_exp'
      end
    end
  end
end
