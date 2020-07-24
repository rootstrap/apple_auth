# frozen_string_literal: true

# Rails Core
require 'active_support/core_ext/hash'
require 'rails/generators'

# Ruby Core
require 'base64'
require 'json'
require 'net/http'

# Gems
require 'jwt'
require 'oauth2'

# Files
require 'apple_sign_in/config'
require 'apple_sign_in/helpers/conditions/jwt_validation_error'

require 'apple_sign_in/helpers/conditions/aud_condition'
require 'apple_sign_in/helpers/conditions/exp_condition'
require 'apple_sign_in/helpers/conditions/iat_condition'
require 'apple_sign_in/helpers/conditions/iss_condition'
require 'apple_sign_in/helpers/jwt_conditions'

require 'apple_sign_in/user_identity'
require 'apple_sign_in/token'

require 'generators/apple_sign_in/config/config_generator'
