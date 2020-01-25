# frozen_string_literal: true

require "spec_helper"

RSpec.describe Jacks::Request::TypeHandler::Favicon do
  around do |example|
    asset_server = ENV["ASSET_SERVER"]
    ENV["ASSET_SERVER"] = "http://localhost:5001"
    example.run
    ENV["ASSET_SERVER"] = asset_server
  end

  it ".match? if the path is directly to /favicon.ico" do
    expect(Jacks::Request::TypeHandler::Favicon.match?(
      double(path: "/favicon.ico")
    )).to eq(true)
  end

  it ".match? is false for other paths" do
    expect(Jacks::Request::TypeHandler::Favicon.match?(
      double(path: "/images/favicon-32.ico")
    )).to eq(false)
  end

  it "#call proxyies paths to the first favicon in the manifest" do
    app_data = Jacks::Config::AppData.load
    allow(app_data).to receive(:manifest).and_return(
      double("manifest",
        assets: {
          "index.8b313f72.html" => "index.8b313f72.html",
          "images/favicon-16.ico" => "images/favicon-16.83858da25c0ed9775b130c997e353706.ico",
          "images/favicon-32.ico" => "images/favicon-32.1a8bdbee6d1b9c435bb2aa5dd553e99b.ico",
        })
    )

    env = {
      "PATH_INFO" => "/favicon.ico",
    }

    request = Jacks::Request::Data.new(env)

    expect(RestClient::Request).to receive(:execute) do |options|
      expect(options[:url]).to eq(
        "http://localhost:5001/images/favicon-16.83858da25c0ed9775b130c997e353706.ico"
      )
      double(
        code: 200,
        headers: {},
        body: "response body"
      )
    end

    response = Jacks::Request::TypeHandler::Favicon.new(request, app_data).call
    expect(response[0]).to eq(200)
    expect(response[2][0]).to eq("response body")
  end

  it "#call in production will catch timeout errors and return a response" do
    request = Jacks::Request::Data.new("PATH_INFO" => "/favicon.ico")

    app_data = Jacks::Config::AppData.load
    allow(app_data.environment).to receive(:catch_errors?).and_return(true)
    allow(app_data).to receive(:manifest).and_return(
      double("manifest",
        assets: {
          "images/favicon-16.ico" => "images/favicon-16.83858da25c0ed9775b130c997e353706.ico",
          "images/favicon-32.ico" => "images/favicon-32.1a8bdbee6d1b9c435bb2aa5dd553e99b.ico",
        })
    )

    expect(RestClient::Request).to receive(:execute).and_raise(
      RestClient::Exceptions::Timeout.new("Request timed out")
    )

    response = Jacks::Request::TypeHandler::Favicon.new(request, app_data).call
    expect(response[0]).to eq(503)
    expect(response[2][0]).to eq("Request timed out")
  end
end
