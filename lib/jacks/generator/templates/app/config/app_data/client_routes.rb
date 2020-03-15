module Config
  module AppData
    class ClientRoutes < Jacks::Config::AppData::ClientRoutes
      def routes
        [
          route("/app", "/"),
        ]
      end
    end
  end
end
