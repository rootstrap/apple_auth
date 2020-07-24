# frozen_string_literal: true

module AppleSignIn
  module Conditions
    class AudCondition
      def initialize(jwt)
        @aud = jwt['aud']
      end

      def validate!
        return true if @aud == AppleSignIn.config.apple_client_id

        raise JWTValidationError, 'jwt_aud is different to apple_client_id'
      end
    end
  end
end
