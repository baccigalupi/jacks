# frozen_string_literal: true

module Jacks
  module Config
    class AppData
      attr_reader :app_env, :root_dir

      def initialize(app_env, root)
        @app_env = app_env
        @root_dir = root
      end

      def self.load(app_env = determine_env, root = Dir.pwd)
        new(app_env, root).load
      end

      def load
        data = initial_data
        classes.each do |klass|
          klass.decorate(data)
        end
        data
      end

      def self.determine_env
        ENV["APP_ENV"] || "development"
      end

      private

      def initial_data
        OpenStruct.new(
          app_env: app_env,
          root_dir: root_dir
        )
      end

      def classes
        ordered_classes + Config::AppData.constants(true)
          .map { |symbol| Config::AppData.const_get(symbol) }
          .filter { |const| const.is_a?(Module) }
          .reject { |const| ordered_classes.include?(const) }
      end

      def ordered_classes
        [
          Config::AppData::Environment,
          Config::AppData::Logger,
        ]
      end
    end
  end
end
