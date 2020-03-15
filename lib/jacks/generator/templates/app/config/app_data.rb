module Config
  class AppData < Jacks::Config::AppData
    def classes
      [
        Jacks::Config::AppData::Environment,
        Jacks::Config::AppData::Logger,
        Jacks::Config::AppData::AssetManifest,
        Jacks::Config::AppData::ProxyCache,
  
        Config::AppData::ClientRoutes,
        Config::AppData::JsonRoutes,
        Config::AppData::Sequel
      ]
    end
  end
end
