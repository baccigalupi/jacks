# frozen_string_literal: true

module Jacks
  module Config
    class AppData
      class ProxyCache < Jacks::App::DataDecorator
        def name
          "proxy_cache"
        end

        def exist?(path)
          return false if ignore?

          !store[path].nil?
        end

        def get(path)
          store[path]
        end

        def set(path, value)
          return value if ignore?
          return value if failed?(value)

          store[path] = value
          value
        end

        private

        def store
          @store ||= {}
        end

        def ignore?
          environment.local?
        end

        def failed?(response)
          response[0] >= 400
        end
      end
    end
  end
end
