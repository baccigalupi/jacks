# frozen_string_literal: true

module Jacks
  module Proxy
    class Page
      attr_reader :path, :manifest

      def initialize(path, manifest)
        @path = path
        @manifest = manifest
      end

      def matching_page
        return matching_named_page if matching_named_page

        matching_index_html ? "/#{matching_index_html}" : not_found_page
      end

      def error_page
        "/#{error_html}"
      end

      def not_found_page
        "/#{not_found_html}"
      end

      private

      def index_matcher
        page = path == "/" ? "" : path
        Regexp.new("^#{page}\/index\.[a-f0-9]+\.html$")
      end

      def matching_named_page
        return @matching_named_page if defined?(@matching_named_page)

        named_path = path[0] == '/' ? path[1..] : path
        match = matching_page_html(named_path)
        @matching_named_page = match ? "/#{match}" : nil
      end

      def matching_index_html
        @matching_index_html ||= manifest
          .keys
          .detect { |key| "/#{key}".match?(index_matcher) }
      end

      def page_matcher(page)
        Regexp.new("^#{page}.[a-f0-9]+\.html$")
      end

      def matching_page_html(page)
        manifest
          .keys
          .detect { |key| key.match?(page_matcher(page)) }
      end

      def error_html
        matching_page_html("error") || fallback
      end

      def not_found_html
        matching_page_html("not-found") || error_html
      end

      def fallback
        "error.html"
      end
    end
  end
end
