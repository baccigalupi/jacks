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
        configure_strategies
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
        return unless environment.local?
        config(:developer, OmniAuth::Strategies::Developer)
      end

      def config(key, *strategy_args)
        rack_app.use(*strategy_args)
        rack_app.map("/auth/#{key}/callback") {
          use Jacks::Config::Middlewares::OmniauthAuthenticator::App
        }
      end

      def configure_strategies
        # Examples:
        #
        # config(
        #   :google_oauth2,
        #   OmniAuth::Strategies::GoogleOauth2,
        #   ENV.fetch("GOOGLE_CLIENT_ID"),
        #   ENV.fetch("GOOGLE_CLIENT_SECRET")
        # )
        #
        # config(
        #   :github,
        #   OmniAuth::Strategies::Github,
        #   ENV.fetch("GITHUB_CLIENT_ID"),
        #   ENV.fetch("GITHUB_CLIENT_SECRET")
        # )
      end

      def environment
        app_data.environment
      end
    end
  end
end
