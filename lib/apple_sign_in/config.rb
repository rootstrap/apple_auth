# frozen_string_literal: true

module AppleSignIn
  class << self
    def configure
      yield config
    end

    def reset_configuration
      @config = Config.new
    end

    def config
      @config ||= Config.new
    end
  end

  class Config
    attr_accessor :apple_client_id, :apple_private_key, :apple_key_id,
                  :apple_team_id, :redirect_uri
  end
end
