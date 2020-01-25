# frozen_string_literal: true

require "spec_helper"

RSpec.describe Jacks::Config::AppData::Environment do
  it 'adds itself to the data object via "enviornment"' do
    data = OpenStruct.new(app_env: "development")
    Jacks::Config::AppData::Environment.decorate(data)

    expect(data.environment).to be_a(Jacks::Config::AppData::Environment)
    expect(data.environment.app_env).to eq(data.app_env)
  end

  it "will not load .env files when in production" do
    data = OpenStruct.new(app_env: "production")
    environment = Jacks::Config::AppData::Environment.new(data)

    expect(Dotenv).not_to receive(:load)
    environment.load!
  end

  it "loads only .env in development mode" do
    data = OpenStruct.new(app_env: "development")
    environment = Jacks::Config::AppData::Environment.new(data)

    expect(Dotenv).to receive(:load).with(".env")
    environment.load!
  end

  it "loads only .env.test too in test mode" do
    data = OpenStruct.new(app_env: "test")
    environment = Jacks::Config::AppData::Environment.new(data)

    expect(Dotenv).to receive(:load).with(".env.test", ".env")
    environment.load!
  end

  it "will load production env file for asset compilation" do
    data = OpenStruct.new(app_env: "production")
    environment = Jacks::Config::AppData::Environment.new(data)

    expect(Dotenv).to receive(:load).with(".env.production", ".env")
    environment.load_for_asset_compilation!
  end

  it "catches errors only in production" do
    data = OpenStruct.new(app_env: "production")
    environment = Jacks::Config::AppData::Environment.new(data)
    expect(environment.catch_errors?).to eq(true)

    data = OpenStruct.new(app_env: "development")
    environment = Jacks::Config::AppData::Environment.new(data)
    expect(environment.catch_errors?).to eq(false)

    data = OpenStruct.new(app_env: "test")
    environment = Jacks::Config::AppData::Environment.new(data)
    expect(environment.catch_errors?).to eq(false)
  end

  it "considers local work to be test and development" do
    data = OpenStruct.new(app_env: "production")
    environment = Jacks::Config::AppData::Environment.new(data)
    expect(environment.local?).to eq(false)

    data = OpenStruct.new(app_env: "development")
    environment = Jacks::Config::AppData::Environment.new(data)
    expect(environment.local?).to eq(true)

    data = OpenStruct.new(app_env: "test")
    environment = Jacks::Config::AppData::Environment.new(data)
    expect(environment.local?).to eq(true)
  end

  it "only logs to file in test" do
    data = OpenStruct.new(app_env: "production")
    environment = Jacks::Config::AppData::Environment.new(data)
    expect(environment.log_to_file?).to eq(false)

    data = OpenStruct.new(app_env: "development")
    environment = Jacks::Config::AppData::Environment.new(data)
    expect(environment.log_to_file?).to eq(false)

    data = OpenStruct.new(app_env: "test")
    environment = Jacks::Config::AppData::Environment.new(data)
    expect(environment.log_to_file?).to eq(true)
  end
end
