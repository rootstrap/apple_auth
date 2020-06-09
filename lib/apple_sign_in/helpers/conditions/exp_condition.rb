# frozen_string_literal: true

module AppleSignIn
  module Conditions
    class ExpCondition
      def initialize(jwt)
        @exp = jwt['exp'].to_i
      end

      def valid?
        @exp > Time.now.to_i
      end
    end
  end
end
