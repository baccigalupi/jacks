# frozen_string_literal: true

module Jacks
  module Path
    class CompareParts
      attr_reader :left, :right

      def initialize(pair)
        @left = Part.decorate(pair.first)
        @right = Part.decorate(pair.last)
        @left, @right = [@right, @left] if right.param? || right.glob?
      end

      def match?
        return true if left == right

        param_matching? || glob_matching?
      end

      def params
        return extracted_params if param_matching? || glob_matching?

        {}
      end

      private

      def param_matching?
        return false if left.param? && right.param?

        left.param? && right.valid?
      end

      def glob_matching?
        return false if left.glob? && right.glob?

        left.glob? && right.valid?
      end

      def extracted_params
        {left[1..] => right.value}
      end
    end
  end
end
