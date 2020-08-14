# frozen_string_literal: true

module AppleAuth
  module Generators
    class AppleAuthControllerGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)
      argument :scope, required: false, default: ''

      def copy_apple_auth_controller_file
        @scope_prefix = scope.blank? ? '' : scope.camelize
        template 'apple_auth_controller.rb',
                 "app/controllers/#{scope}apple_auth_controller.rb"
      end
    end
  end
end
