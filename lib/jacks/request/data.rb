# frozen_string_literal: true

module Jacks
  module Request
    class Data
      attr_reader :env

      def initialize(env)
        @env = env
      end

      def path
        env["REQUEST_PATH"] || env["PATH_INFO"] || "/"
      end

      def json_payload
        @json_payload ||= JSON.parse(rack_input)
      end

      def rack_input
        env["rack.input"].read
      rescue
        "{}"
      end

      def path_without_extension
        path.sub(extension, "")
      end

      def params
        @params ||= query_string
          .split("&")
          .map { |key_value| key_value.split("=") }
          .to_h
      end

      def add_params(path_params)
        params
        @params.merge(path_params)
        params
      end

      def method
        @method ||= Method.new(env, params).with_override
      end

      def json?
        content_type == "json"
      end

      def static?
        return false if json?
        return true if extension != ""

        false
      end

      def content_type
        return "json" if json_file_type?

        env_content_type.split("/").last
      end

      def query_string
        env["QUERY_STRING"] || ""
      end

      private

      def extension
        File.extname(path)
      end

      def json_file_type?
        extension == ".json"
      end

      def env_content_type
        env["CONTENT_TYPE"] || default_content_type
      end

      def default_content_type
        "text/html"
      end
    end
  end
end
