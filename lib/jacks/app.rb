# frozen_string_literal: true

module Jacks
  class App
    extend Forwardable

    attr_reader :app_data

    def initialize(app_data)
      @app_data = app_data
      app_data.logger.info(
        "Jacks is running in #{app_data.environment.app_env}\n\n"
      )
    end

    def call(env)
      request = Request::Data.new(env)
      request_handler(request).new(request, app_data).call
    end

    def request_handler(request)
      type_handlers.find { |klass| klass.match?(request) }
    end

    def type_handlers
      [
        Request::TypeHandler::Json,
        Request::TypeHandler::Favicon,
        Request::TypeHandler::Static,
        Request::TypeHandler::Html,
      ]
    end
  end
end
