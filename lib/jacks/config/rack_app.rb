# frozen_string_literal: true

module Jacks
  module Config
    class RackApp
      def config
        load_app_data
        config_middleware
        config_app

        rack_app.to_app
      end

      def app_data
        @app_data = ::Config::AppData.load
      end

      alias load_app_data app_data

      def config_app
        # template method for subclasses
      end

      def environment
        app_data.environment
      end

      def logger
        app_data.logger
      end

      def jacks_app
        Jacks::App.new(app_data)
      end

      def rack_app
        @rack_app ||= Rack::Builder.new
      end

      def config_middleware
        config_rack_extensions
        config_jacks_data
        config_authentication
        config_to_run_jacks
      end

      def config_rack_extensions
        rack_app.use(Rack::Reloader) if environment.local?
        rack_app.use(Rack::ContentLength)
        rack_app.use(Rack::CommonLogger, logger)
      end

      def config_jacks_data
        rack_app.use(Jacks::Middlewares::AppData.config(app_data))
        rack_app.use(Jacks::Middlewares::JacksRequest)
      end

      def config_authentication
        config_omniauth
        rack_app.use(Jacks::Middlewares::JwtData)
      end

      def config_omniauth
        raise NotImplementedError
      end

      def config_to_run_jacks
        rack_app.run(jacks_app)
      end
    end
  end
end
