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
require 'apple_auth/config'
require 'apple_auth/helpers/conditions/jwt_validation_error'

require 'apple_auth/helpers/conditions/aud_condition'
require 'apple_auth/helpers/conditions/exp_condition'
require 'apple_auth/helpers/conditions/iat_condition'
require 'apple_auth/helpers/conditions/iss_condition'
require 'apple_auth/helpers/jwt_conditions'
require 'apple_auth/helpers/jwt_decoder'
require 'apple_auth/helpers/jwt_server_conditions'

require 'apple_auth/server_identity'
require 'apple_auth/user_identity'
require 'apple_auth/token'

require 'generators/apple_auth/config/config_generator'
require 'generators/apple_auth/apple_auth_controller/apple_auth_controller_generator'
