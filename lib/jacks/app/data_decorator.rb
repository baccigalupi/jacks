# frozen_string_literal: true

module Jacks
  class App
    class DataDecorator
      extend Forwardable

      attr_reader :app_data

      def initialize(app_data)
        @app_data = app_data
      end

      def decorate
        app_data.send("#{name}=", self)
      end

      def self.decorate(app_data)
        new(app_data).decorate
      end

      private

      def name
        raise NotImplementedError
      end

      def_delegators :app_data, :environment, :logger
    end
  end
end
