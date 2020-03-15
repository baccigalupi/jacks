module Config
  class RackApp < Jacks::Config::RackApp
    def config_app
      # Add your middleware here
      # Example:
      #
      # rack_app.use(Rack::Throttle::Interval)
    end

    def config_omniauth
      ::Config::Middlewares::OmniauthConfig.new(rack_app, app_data).setup
    end
  end
end
