# frozen_string_literal: true

module Jacks
  module Path
    class Part < SimpleDelegator
      def glob?
        value.start_with?("*")
      end

      def param?
        value.start_with?(":")
      end

      def valid?
        true
      end

      def value
        __getobj__
      end

      def self.decorate(obj)
        if obj.nil? || obj.empty?
          NullPart.new
        else
          Part.new(obj)
        end
      end
    end
  end
end
