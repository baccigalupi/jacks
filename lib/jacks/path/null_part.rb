# frozen_string_literal: true

module Jacks
  module Path
    class NullPart
      def glob?
        false
      end

      def param?
        false
      end

      def valid?
        false
      end

      def value
        nil
      end
    end
  end
end
