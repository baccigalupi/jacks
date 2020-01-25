# frozen_string_literal: true

require "spec_helper"

RSpec.describe Jacks::Middlewares::JwtData do
  around do |example|
    key = ENV["SECRET_KEY_BASE"]
    ENV["SECRET_KEY_BASE"] = "secret-sauce"
    example.run
    ENV["SECRET_KEY_BASE"] = key
  end

  it "adds data to the env on successful decoding" do
    token = Jacks::Jwt::Token.encode(
      exp: Time.now.to_i + 3600,
      profile_id: 123
    )

    env = {
      "QUERY_STRING" => "token=#{token}",
    }

    rack_app = double("Rack app")
    expect(rack_app).to receive(:call) do |decorated_env|
      expect(decorated_env["jacks.jwt_data"]).to eq("profile_id" => 123)
      expect(decorated_env["jacks.jwt_error"]).to eq(nil)
    end

    middleware = Jacks::Middlewares::JwtData.new(rack_app)
    middleware.call(env)
  end

  it "adds an error to the env if something goes wrong" do
    token = Jacks::Jwt::Token.encode(
      exp: Time.now.to_i - 3600,
      profile_id: 123
    )

    env = {
      "QUERY_STRING" => "token=#{token}",
    }

    rack_app = double("Rack app")
    expect(rack_app).to receive(:call) do |decorated_env|
      expect(decorated_env["jacks.jwt_data"]).to eq({})
      expect(decorated_env["jacks.jwt_error"]).to be_a(JWT::ExpiredSignature)
    end

    middleware = Jacks::Middlewares::JwtData.new(rack_app)
    middleware.call(env)
  end
end
