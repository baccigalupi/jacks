# frozen_string_literal: true

module Jacks
  module Middlewares
    class JwtData
      attr_reader :app

      def initialize(app)
        @app = app
      end

      def call(env)
        decorate_env(env)
        app.call(env)
      end

      def decorate_env(env)
        extractor = Jwt::ExtractFromEnv.new(env)

        env["jacks.jwt_data"] = extractor.data
        env["jacks.jwt_error"] = extractor.error if extractor.error?
      end
    end
  end
end
