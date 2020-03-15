# frozen_string_literal: true

app_path = File.expand_path(File.join(__dir__, "app"))
$LOAD_PATH.unshift(app_path) unless $LOAD_PATH.include?(app_path)

require "jacks"

loader = Jacks::AppLoader.new(__dir__)

require("config/rack_app")
loader.require_dir("config/app_data")
loader.require_dir("config/middlewares")

loader.require_dir("server/controllers")
loader.require_dir("server/db")
loader.require_dir("server/domain")