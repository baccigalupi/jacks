# frozen_string_literal: true

module Jacks
  module Config
    class AppData
      class Sequel
        extend Forwardable

        attr_reader :app_data

        def initialize(app_data)
          @app_data = app_data
        end

        def decorate
          app_data.sequel = self
          def app_data.db
            sequel.db
          end
          app_data
        end

        def self.decorate(app_data)
          new(app_data).decorate
        end

        def db
          @db ||= ::Sequel.connect(url, logger: logger)
        end

        def database_name
          "#{database_prefix}_#{environment.app_env}"
        end

        def url
          return env["DATABASE_URL"] if env["DATABASE_URL"]

          "postgres://#{username}:#{password}@#{host}:#{port}/#{database_name}"
        end

        private

        def username
          env.fetch("DATABASE_USER", `whoami`.strip)
        end

        def password
          env.fetch("DATABASE_PASSWORD", "")
        end

        def host
          env.fetch("DATABASE_HOST", "localhost")
        end

        def port
          env.fetch("DATABASE_PORT", "5432")
        end

        def database_prefix
          "jacks"
        end

        def env
          environment.env_vars
        end

        def_delegators :app_data, :environment, :logger
      end
    end
  end
end
