module Jacks
  module Tasks
    class Db
      attr_reader :app_root

      def initialize(app_root)
        @app_root = app_root
      end

      def create
        environments_app_data.each do |app_data|
          `createdb #{app_data.sequel.database_name}`
        end
      end

      def drop
        environments_app_data.each do |app_data|
          `createdb #{app_data.sequel.database_name}`
        end
      end

      def migrate(options)
        environments_app_data.each do |app_data|
          Sequel.connect(app_data.sequel.url, logger: Logger.new($stdout)) do |db|
            Sequel::Migrator.run(db, migrations_path, options)
          end
        end
      end

      def generate_migration(name = "name_this_migration")
        timestamp = Time.now.to_i
        filename = "#{migrations_path}/#{timestamp}_#{name}.rb"

        File.open(filename, "w") do |file|
          file.write(migration_template)
        end
      end

      def schema_dump
        return if current_environment_app_data.app_env == "production"

        `sequel #{current_environment_app_data.sequel.url} --dump-migration > #{db_path}/schema.rb`
      end

      private

      def environments_app_data
        @environments_app_data ||= environments.map { |app_env|
          ::Config::AppData.load(app_env)
        }
      end

      def current_environment_app_data
        ::Config::AppData.load
      end

      def environments
        ["production"] if ENV["APP_ENV"] == "production"
        ["test", "development"]
      end

      def migrations_path
        "#{db_path}/migrations"
      end

      def db_path
        File.expand_path(
          File.join(current_environment_app_data.root, "app/config/db")
        )
      end

      def migration_template
        template = <<~MIGRATION
          Sequel.migration do
            transaction
            change do
  
            end
          end
        MIGRATION
      end
    end
  end
end
