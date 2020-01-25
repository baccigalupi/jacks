# frozen_string_literal: true

module Jacks
  module Config
    class AppData
      class Logger
        extend Forwardable

        attr_reader :app_data

        def initialize(app_data)
          @app_data = app_data
        end

        def self.decorate(app_data)
          app_data.logger = new(app_data).build_logger
          app_data
        end

        def build_logger
          logger = ::Logger.new(log_output)
          logger.level = level
          logger
        end

        private

        def log_output
          return log_file if environment.log_to_file?

          $stdout
        end

        def level
          return ::Logger::DEBUG if environment.local?

          ::Logger::INFO
        end

        def log_file
          File.join(app_data.root_dir, "app/log/#{app_data.app_env}.log")
        end

        def_delegators :app_data, :environment
      end
    end
  end
end
