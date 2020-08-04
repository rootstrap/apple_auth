# frozen_string_literal: true

module AppleAuth
  module Generators
    class AppleSignInControllerGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)
      argument :scope, required: false, default: ''

      def copy_apple_sign_in_controller_file
        @scope_prefix = scope.blank? ? '' : scope.camelize
        template 'apple_sign_in_controller.rb',
                 "app/controllers/#{scope}apple_sign_in_controller.rb"
      end
    end
  end
end
