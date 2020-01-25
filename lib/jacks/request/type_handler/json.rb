# frozen_string_literal: true

module Jacks
  module Request
    module TypeHandler
      class Json
        attr_reader :request, :app_data

        def initialize(request, app_data)
          @request = request
          @app_data = app_data
        end

        def call
          controller.new(request, app_data).call
        rescue => e
          handle_error(e)
        end

        def self.match?(request)
          request.json?
        end

        private

        def route_matcher
          app_data.routes
            .map { |route| Request::RouteMatch.new(route, request) }
            .detect(&:match?)
        end

        def controller
          return not_found unless route_matcher

          route_matcher.route.controller
        end

        def not_found
          Jacks::JsonResponse.new(404, {error: "Not found"})
        end

        def error_response(error)
          Jacks::JsonResponse.new(500, {error: error.message}).to_rack
        end

        def handle_error(error)
          return error_response(error) if app_data.environment.catch_errors?

          raise error
        end
      end
    end
  end
end
