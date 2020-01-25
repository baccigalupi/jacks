# frozen_string_literal: true

module Jacks
  module Config
    class AppData
      class Environment < Jacks::App::DataDecorator
        attr_reader :env_vars

        def initialize(data)
          super
          @env_vars = ENV
          load!
        end

        def name
          "environment"
        end

        def app_env
          app_data.app_env
        end

        def load!
          return if production?

          files = [".env"]
          files.unshift(".env.test") if test?

          load_files(files)
        end

        def load_for_asset_compilation!
          load_files([".env.production", ".env"])
        end

        def production?
          ["production"].include?(app_env)
        end

        def development?
          ["development"].include?(app_env)
        end

        def test?
          ["test"].include?(app_env)
        end

        def catch_errors?
          production?
        end

        def local?
          development? || test?
        end

        def log_to_file?
          test?
        end

        private

        def load_files(files)
          require "dotenv"
          Dotenv.load(*files)
          @env_vars = ENV
        end
      end
    end
  end
end
