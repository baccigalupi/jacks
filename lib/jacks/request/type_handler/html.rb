# frozen_string_literal: true

module Jacks
  module Request
    module TypeHandler
      class Html
        attr_reader :request, :app_data

        def initialize(request, app_data)
          @request = request
          @app_data = app_data
        end

        def self.match?(_request)
          true
        end

        def call
          Jacks::Proxy::Request.new(
            matching_html,
            app_data
          ).call
        rescue RestClient::Exceptions::Timeout => e
          handle_error(e)
        end

        private

        def matching_html
          Proxy::Page.new(request_path, app_data.manifest.assets).matching_page
        end

        def request_path
          client_path || request.path
        end

        def client_path
          return unless app_data.client_routes

          matching_route = app_data.client_routes.detect { |route|
            request.path.start_with?(route.client_path)
          }

          return matching_route.html_path if matching_route
        end

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
