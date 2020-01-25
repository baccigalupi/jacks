# frozen_string_literal: true

require "spec_helper"

RSpec.describe Jacks::Middlewares::JacksRequest do
  it "adds data to the env on successful decoding" do
    env = {}

    rack_app = double("Rack app")
    expect(rack_app).to receive(:call) do |decorated_env|
      expect(decorated_env["jacks.request"]).to be_a(Jacks::Request::Data)
    end

    middleware = Jacks::Middlewares::JacksRequest.new(rack_app)
    middleware.call(env)
  end
end
