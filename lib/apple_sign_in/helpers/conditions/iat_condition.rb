# frozen_string_literal: true

module AppleSignIn
  module Conditions
    class IatCondition
      def initialize(jwt)
        @iat = jwt['iat'].to_i
      end

      def valid?
        @iat <= Time.now.to_i
      end
    end
  end
end
