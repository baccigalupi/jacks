module Config
  module AppData
    class JsonRoutes < Jacks::Config::AppData::JsonRoutes
      def routes
        [
          # route("GET", "/on_app_load", Controllers::OnAppLoad),
        ]
      end
    end
  end
end
