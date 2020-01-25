# frozen_string_literal: true

module Jacks
  module Config
    class AppData
      class JsonRoutes
        def self.decorate(data)
          data.routes = new.routes
        end

        def routes
          [
            # route("GET", "/about/*page", Controllers::CMS),
          ]
        end

        def route(method, path, controller)
          Jacks::Route.new(method.upcase, path.downcase, controller)
        end
      end
    end
  end
end
