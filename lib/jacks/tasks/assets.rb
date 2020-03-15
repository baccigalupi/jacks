require "dotenv"
require "jacks/cdn/s3"

module Jacks
  module Tasks
    class Assets
      attr_reader :root

      def initialize(root)
        @root = root
      end

      def compile_production_assets
        `npm run assets:prod`
      end

      def upload_assets
        compile_production_assets
        upload
      end

      private

      def app_data
        ::Config::AppData.load("production", root)
      end

      def upload
        Jacks::CDN::S3.new(
          "#{root}/app/compiled_assets",
          app_data.manifest
        ).upload_assets!
      end
    end
  end
end
