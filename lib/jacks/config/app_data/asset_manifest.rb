# frozen_string_literal: true

module Jacks
  module Config
    class AppData
      class AssetManifest < Jacks::App::DataDecorator
        def name
          "manifest"
        end

        def assets
          return load_assets if environment.development?

          @assets ||= load_assets
        end

        private

        def load_assets
          JSON.parse(File.read(path))
        rescue
          null_with_warning
        end

        def path
          File.expand_path(
            File.join(
              root, "/app/client/#{filename}.json"
            )
          )
        end

        def root
          app_data.root || Dir.pwd
        end

        def filename
          return "manifest.local" if environment.local?

          "manifest"
        end

        def null_with_warning
          warn "couldn't find manifest.json at #{path}"
          {}
        end
      end
    end
  end
end
