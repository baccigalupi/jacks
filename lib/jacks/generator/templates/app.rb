# frozen_string_literal: true

app_path = File.expand_path(File.join(__dir__, "app"))
$LOAD_PATH.unshift(app_path) unless $LOAD_PATH.include?(app_path)

require "jacks"

module AppLoader
  def self.root_dir
    File.expand_path(__dir__)
  end

  def self.require_dir(app_dir)
    Dir[
      File.join(root_dir, "app", app_dir, "**/*.rb")
    ].each { |file| require file }
  end
end

require("config/rack_app")
AppLoader.require_dir("config/app_data")
AppLoader.require_dir("config/middlewares")

AppLoader.require_dir("server/controllers")
AppLoader.require_dir("server/db")
AppLoader.require_dir("server/domain")
