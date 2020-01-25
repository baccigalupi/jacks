# frozen_string_literal: true

require "spec_helper"

RSpec.describe Jacks::Middlewares::AppData do
  it "adds data to the env on successful decoding" do
    env = {}
    app_data = Jacks::Config::AppData.load

    rack_app = double("Rack app")
    expect(rack_app).to receive(:call) do |decorated_env|
      expect(decorated_env["jacks.app_data"]).to eq(app_data)
    end

    middleware_class = Jacks::Middlewares::AppData.config(app_data)
    middleware = middleware_class.new(rack_app)
    middleware.call(env)
  end
end
