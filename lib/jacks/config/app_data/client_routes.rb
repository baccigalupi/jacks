# frozen_string_literal: true

module Jacks
  module Config
    class AppData
      class ClientRoutes
        def self.decorate(data)
          data.client_routes = new.routes
        end

        def routes
          [
            route("/app", "/"),
            route("/admin", "/admin"),
          ]
        end

        def route(client_path, html_path)
          ClientRoute.new(client_path, html_path)
        end

        ClientRoute = Struct.new(:client_path, :html_path)
      end
    end
  end
end
