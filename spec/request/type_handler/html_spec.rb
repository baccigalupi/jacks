# frozen_string_literal: true

require "spec_helper"

RSpec.describe Jacks::Request::TypeHandler::Html do
  around do |example|
    asset_server = ENV["ASSET_SERVER"]
    ENV["ASSET_SERVER"] = "http://localhost:5001"
    example.run
    ENV["ASSET_SERVER"] = asset_server
  end

  it ".match? is the fallback and is always true" do
    expect(Jacks::Request::TypeHandler::Html.match?(double)).to eq(true)
  end

  it "#call proxies paths to the right html asset file" do
    app_data = Jacks::Config::AppData.load
    allow(app_data).to receive(:manifest).and_return(
      double("manifest",
        assets: {"index.8b313f72.html" => "index.8b313f72.html"})
    )

    env = {
      "PATH_INFO" => "/",
    }

    request = Jacks::Request::Data.new(env)

    expect(RestClient::Request).to receive(:execute) do |options|
      expect(options[:url]).to eq("http://localhost:5001/index.8b313f72.html")
      double(
        code: 200,
        headers: {},
        body: "response body"
      )
    end

    response = Jacks::Request::TypeHandler::Html.new(request, app_data).call
    expect(response[0]).to eq(200)
    expect(response[2][0]).to eq("response body")
  end

  it "#call proxies client side applications to the right html page" do
    app_data = Jacks::Config::AppData.load
    allow(app_data).to receive(:manifest).and_return(
      double("manifest",
        assets: {"index.8b313f72.html" => "index.8b313f72.html"})
    )
    allow(app_data).to receive(:client_routes).and_return(
      [
        OpenStruct.new(client_path: "/app", html_path: "/"),
        OpenStruct.new(client_path: "/admin", html_path: "/admin"),
      ]
    )

    env = {
      "PATH_INFO" => "/app/foo/bar",
    }

    request = Jacks::Request::Data.new(env)

    expect(RestClient::Request).to receive(:execute) do |options|
      expect(options[:url]).to eq("http://localhost:5001/index.8b313f72.html")
      double(
        code: 200,
        headers: {},
        body: "response body"
      )
    end

    response = Jacks::Request::TypeHandler::Html.new(request, app_data).call
    expect(response[0]).to eq(200)
    expect(response[2][0]).to eq("response body")
  end

  it "#call in production will catch timeout errors and return a response" do
    request = Jacks::Request::Data.new("PATH_INFO" => "/app.123abchash.js")

    app_data = Jacks::Config::AppData.load
    allow(app_data.environment).to receive(:catch_errors?).and_return(true)
    allow(app_data).to receive(:manifest).and_return(
      double("manifest",
        assets: {
          "index.8b313f72.html" => "index.8b313f72.html",
        })
    )

    expect(RestClient::Request).to receive(:execute).and_raise(
      RestClient::Exceptions::Timeout.new("Request timed out")
    )

    response = Jacks::Request::TypeHandler::Html.new(request, app_data).call
    expect(response[0]).to eq(503)
    expect(response[2][0]).to eq("Request timed out")
  end
end
