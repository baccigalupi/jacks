# frozen_string_literal: true

module Jacks
  module OmniauthAuthenticator
    class Config
      attr_reader :rack_app, :app_data

      def initialize(rack_app, app_data)
        @rack_app = rack_app
        @app_data = app_data
      end

      def setup
        setup_logging
        add_cookie_sessions
        add_developer_strategy
        add_other_strategies

        map_callbacks
      end

      private

      def setup_logging
        OmniAuth.config.logger = app_data.logger
      end

      def add_cookie_sessions
        rack_app.use(
          Rack::Session::Cookie,
          secret: ENV.fetch("SECRET_KEY_BASE")
        )
      end

      def add_developer_strategy
        rack_app.use(OmniAuth::Strategies::Developer) if environment.local?
      end

      def add_other_strategies
        rack_app.use(
          OmniAuth::Strategies::GoogleOauth2,
          ENV.fetch("GOOGLE_CLIENT_ID"),
          ENV.fetch("GOOGLE_CLIENT_SECRET")
        )
      end

      def map_callbacks
        urls = [
          "/auth/google_oauth2/callback",
        ]
        urls << "/auth/developer/callback" if environment.local?

        urls.each do |url|
          rack_app.map(url) { use OmniauthAuthenticator::App }
        end
      end

      def environment
        app_data.environment
      end
    end
  end
end
