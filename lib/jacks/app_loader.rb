module Jacks
  class AppLoader
    attr_reader :root_dir

    def initialize(root_dir)
      @root_dir = root_dir
    end

    def require_dir(app_dir)
      Dir[
        File.join(root_dir, "app", app_dir, "**/*.rb")
      ].each { |file| require file }
    end
  end
end
