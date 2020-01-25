# frozen_string_literal: true

require "spec_helper"

RSpec.describe Jacks::Request::TypeHandler::Static do
  around do |example|
    asset_server = ENV["ASSET_SERVER"]
    ENV["ASSET_SERVER"] = "http://localhost:5001"
    example.run
    ENV["ASSET_SERVER"] = asset_server
  end

  it ".match? will be true when the request data is #static?" do
    request = double("request", static?: true)
    expect(Jacks::Request::TypeHandler::Static.match?(request)).to eq(true)
  end

  it ".match? will be false when the request is not static" do
    request = double("request", static?: false)
    expect(Jacks::Request::TypeHandler::Static.match?(request)).to eq(false)
  end

  it "#call will proxy the request to the asset server" do
    request = Jacks::Request::Data.new("PATH_INFO" => "/app.123abchash.js")
    app_data = Jacks::Config::AppData.load

    expect(RestClient::Request).to receive(:execute) do |options|
      expect(options[:url]).to eq("http://localhost:5001/app.123abchash.js")
      double(
        code: 200,
        headers: {},
        body: "response body"
      )
    end

    response = Jacks::Request::TypeHandler::Static.new(request, app_data).call
    expect(response[0]).to eq(200)
    expect(response[2][0]).to eq("response body")
  end

  it "#call in production will catch timeout errors and return a response" do
    request = Jacks::Request::Data.new("PATH_INFO" => "/app.123abchash.js")
    app_data = Jacks::Config::AppData.load
    allow(app_data.environment).to receive(:catch_errors?).and_return(true)

    expect(RestClient::Request).to receive(:execute).and_raise(
      RestClient::Exceptions::Timeout.new("Request timed out")
    )

    response = Jacks::Request::TypeHandler::Static.new(request, app_data).call
    expect(response[0]).to eq(503)
    expect(response[2][0]).to eq("Request timed out")
  end
end
