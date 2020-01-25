# frozen_string_literal: true

module Jacks
  module Request
    class Method
      attr_reader :env, :params

      def initialize(env, params)
        @env = env
        @params = params
      end

      def with_override
        return method unless overriding?

        validated_override || method
      end

      private

      def method
        env["REQUEST_METHOD"] || "GET"
      end

      def overriding?
        params.key?("_method")
      end

      def validated_override
        return unless legal_override_method?

        requested_override
      end

      def requested_override
        params["_method"].upcase
      end

      def legal_override_method?
        ["GET", "POST", "PUT", "DELETE", "PATCH"].include?(requested_override)
      end
    end
  end
end
