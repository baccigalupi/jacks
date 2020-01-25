# frozen_string_literal: true

module Jacks
  module Request
    class RouteMatch
      attr_reader :route, :request

      def initialize(route, request)
        @route = route
        @request = request
      end

      def match?
        route.method == request.method &&
          path_comparitor.match?
      end

      def path_params
        path_comparitor.params
      end

      private

      def path_comparitor
        @path_comparitor = Jacks::Path::Match.new(
          route.path,
          request.path_without_extension
        )
      end
    end
  end
end
