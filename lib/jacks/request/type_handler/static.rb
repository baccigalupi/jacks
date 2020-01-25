# frozen_string_literal: true

module Jacks
  module Request
    module TypeHandler
      class Static
        attr_reader :request, :app_data

        def initialize(request, app_data)
          @request = request
          @app_data = app_data
        end

        def call
          Jacks::Proxy::Request.new(
            request.path,
            app_data
          ).call
        rescue RestClient::Exceptions::Timeout => e
          handle_error(e)
        end

        def self.match?(request)
          request.static?
        end

        private

        def handle_error(error)
          return error_response(error) if app_data.environment.catch_errors?

          raise error
        end

        def error_response(error)
          [503, {}, [error.message]]
        end
      end
    end
  end
end
