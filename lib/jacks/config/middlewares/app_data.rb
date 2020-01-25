module Jacks
  module Middlewares
    class AppData
      attr_reader :app

      def initialize(app)
        @app = app
      end

      def call(env)
        env["jacks.app_data"] = self.class.app_data
        app.call(env)
      end

      def self.config(app_data)
        @app_data = app_data
        self
      end

      class << self
        attr_reader :app_data
      end
    end
  end
end
