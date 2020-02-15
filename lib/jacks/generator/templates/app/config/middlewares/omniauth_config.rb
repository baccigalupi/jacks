module Config
  module Middlewares
    class OmniauthConfig < Jacks::OmniauthAuthenticator::Config
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
    end
  end
end
