module Jacks
  module Middlewares
    class JacksRequest
      attr_reader :app

      def initialize(app)
        @app = app
      end

      def call(env)
        env["jacks.request"] = Jacks::Request::Data.new(env)
        app.call(env)
      end
    end
  end
end
