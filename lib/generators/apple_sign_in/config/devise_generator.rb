module AppleSignIn
  module Generators
    class DeviseGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def copy_devise_file

        copy_file 'apple_sing_in_controller.rb', "#{source}apple_sing_in_controller.rb"
      end
    end
  end
end
