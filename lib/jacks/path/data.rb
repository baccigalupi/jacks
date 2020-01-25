# frozen_string_literal: true

module Jacks
  module Path
    class Data
      attr_reader :collection

      def initialize(path)
        @collection = self.class.clean_parts(
          path.split("/")
        )
      end

      def length
        collection.size
      end

      def last_part
        Part.decorate(collection.last)
      end

      def glob?
        last_part.glob?
      end

      def glob_stop
        length - 1
      end

      def glob_path_at(stop)
        @collection = self.class.clean_parts(
          collection[0..stop - 1] + [collection[stop..].join("/")]
        )
      end

      def self.clean_parts(collection)
        collection.reject { |part| part.nil? || part.empty? }
      end
    end
  end
end
