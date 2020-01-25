# frozen_string_literal: true

module Jacks
  module Proxy
    class Request
      attr_reader :path, :app_data

      def initialize(path, app_data)
        @path = path
        @app_data = app_data
      end

      def call
        return cache.get(path) if cache.exist?(path)

        make_request
        cache.set(path, rewrite_response)
      end

      private

      def logger
        app_data.logger
      end

      def cache
        app_data.proxy_cache
      end

      def make_request
        logger.debug("Proxing request: #{url}")
        response
      end

      def response
        @response ||= RestClient::Request.execute(
          method: :get,
          url: url,
          timeout: 10
        )
      end

      def url
        "#{asset_host}#{path}"
      end

      def asset_host
        ENV.fetch("ASSET_SERVER")
      end

      def rewrite_response
        [response.code, headers, [response.body]]
      end

      def headers
        ["date", "last-modified", "etag", "content-type", "content-length"]
          .each_with_object({}) do |header, key|
            header[key] = response.headers[key] if response.headers[key]
          end
      end
    end
  end
end
