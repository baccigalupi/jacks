# frozen_string_literal: true

module Jacks
  module Request
    module TypeHandler
      class Favicon
        attr_reader :request, :app_data

        def initialize(request, app_data)
          @request = request
          @app_data = app_data
        end

        def self.match?(request)
          request.path == "/favicon.ico"
        end

        def call
          Jacks::Proxy::Request.new(
            favicon,
            app_data
          ).call
        rescue RestClient::Exceptions::Timeout => e
          handle_error(e)
        end

        private

        def favicon
          asset = assets.detect { |path| path.match?(/favicon.*.ico$/) }

          return request.path unless asset

          "/#{asset}"
        end

        def handle_error(error)
          return error_response(error) if app_data.environment.catch_errors?

          raise error
        end

        def error_response(error)
          [503, {}, [error.message]]
        end

        def assets
          app_data.manifest.assets.values
        end
      end
    end
  end
end
