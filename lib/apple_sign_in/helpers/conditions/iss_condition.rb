# frozen_string_literal: true

module AppleSignIn
  module Conditions
    class IssCondition
      APPLE_ISS = 'https://appleid.apple.com'

      def initialize(jwt)
        @iss = jwt['iss']
      end

      def valid?
        @iss.include?(APPLE_ISS)
      end
    end
  end
end
