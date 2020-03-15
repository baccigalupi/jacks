require_relative './db'

module Jacks
  module Tasks
    class DbTasks < Rake::TaskLib 
      def self.generate_all
        new.generate_all
      end

      def generate_all
        create_task
        drop_task
        migrate_task
        migrate_create_task
        schema_task
      end

      def create_task
        namespace :db do
          desc "Create databases"
          task :create do
            Jacks::Tasks::Db.new(Dir.pwd).create
          end
        end
      end

      def drop_task
        namespace :db do
          desc "Drop databases"
          task :drop do
            Jacks::Tasks::Db.new(Dir.pwd).drop
          end
        end
      end

      def migrate_create_task
        namespace :db do 
          namespace :migrate do
            desc "Generate a migration file"
            task :create, [:name] do |_t, args|
              name = args[:name] || "name_this_migration"
              Jacks::Tasks::Db.new(Dir.pwd).generate_migration(name)
            end
          end
        end
      end

      def migrate_task
        namespace :db do
          desc "Run up/down all the migrations; use version to set direction"
          task :migrate, [:version] do |_t, args|
            options = {}
            options[:target] = args[:version].to_i if args[:version]

            Jacks::Tasks::Db.new(Dir.pwd).migrate(options)
            Rake::Task["db:schema:dump"].invoke
          end
        end
      end

      def schema_task
        namespace :db do
          namespace :schema do
            desc "Dump schema to file"
            task :dump do
              Jacks::Tasks::Db.new(Dir.pwd).schema_dump
            end
          end
        end
      end
    end
  end
end