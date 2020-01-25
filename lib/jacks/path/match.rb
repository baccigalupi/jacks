# frozen_string_literal: true

module Jacks
  module Path
    class Match
      attr_reader :base, :literal

      def initialize(left, right)
        @base = Path::Data.new(left)
        @literal = Path::Data.new(right)
        @base, @literal = [@literal, @base] if literal.glob?
      end

      def match?
        glob_literal if glob?

        return false if base.length != literal.length

        compare_parts
      end

      def params
        glob_literal if glob?

        comparators.reduce({}) do |collection, comparator|
          collection.merge(comparator.params)
        end
      end

      private

      def glob_literal
        literal.glob_path_at(glob_stop)
      end

      def compare_parts
        comparators.all?(&:match?)
      end

      def comparators
        @comparators ||= base.collection
          .zip(literal.collection)
          .map { |pair| CompareParts.new(pair) }
      end

      def glob?
        base.glob? && literal.length > base.length
      end

      def glob_stop
        base.length - 1
      end
    end
  end
end
