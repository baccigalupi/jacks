# frozen_string_literal: true

module Jacks
  module Jwt
    class ExtractFromEnv
      attr_reader :env, :error

      def initialize(env)
        @env = env
      end

      def data
        return {} unless token

        decode_and_filter
      end

      def error?
        defined?(@error)
      end

      private

      def decode_and_filter
        decoded.reject do |key, _value|
          filtered_keys.include?(key)
        end
      end

      def authorization_header
        env["HTTP_AUTHORIZATION"]
      end

      def token
        header_token || query_token
      end

      def query_token
        Request::Data.new(env).params["token"]
      end

      def header_token
        return nil unless authorization_header

        authorization_header.split(" ").last.strip
      end

      def decoded
        Jwt::Token.decode(token)
      rescue => e
        @error = e
        {}
      end

      def filtered_keys
        ["exp", "iat", "iss"] # Others???
      end
    end
  end
end
