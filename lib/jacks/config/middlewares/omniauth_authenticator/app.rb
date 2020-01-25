# frozen_string_literal: true

module Jacks
  module OmniauthAuthenticator
    class App
      attr_reader :app

      def initialize(app)
        @app = app
      end

      def call(env)
        auth_params = env["omniauth.auth"]
        app_data = env["jacks.app_data"]
        token = ::Authenticator.new(auth_params, app_data.db).call
        redirect_response(token)
      end

      def redirect_response(token)
        [302, {"Location" => "/?token=#{token}"}, []]
      end
    end
  end
end
