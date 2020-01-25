# frozen_string_literal: true

require "spec_helper"

RSpec.describe Jacks::App do
  around do |example|
    asset_server = ENV["ASSET_SERVER"]
    ENV["ASSET_SERVER"] = "http://localhost:5001"
    example.run
    ENV["ASSET_SERVER"] = asset_server
  end

  it "matches the incoming route to a configured json route" do
    controller = double("controller", call: "response")
    allow(controller).to receive(:new).and_return(controller)

    app_data = Jacks::Config::AppData.load
    app_data.routes = [
      Jacks::Route.new("GET", "/foo/:id", controller),
    ]

    app = Jacks::App.new(app_data)

    response = app.call(
      "PATH_INFO" => "/foo/bar",
      "REQUEST_METHOD" => "GET",
      "CONTENT_TYPE" => "application/json"
    )

    expect(response).to eq("response")
  end

  it "proxies bald favicon requests to the right image asset" do
    app_data = Jacks::Config::AppData.load
    allow(app_data).to receive(:manifest).and_return(double(
      assets: {
        "images/favicon-16.ico" =>
          "images/favicon-16.83858da25c0ed9775b130c997e353706.ico",
        "images/favicon-32.ico" =>
          "images/favicon-32.1a8bdbee6d1b9c435bb2aa5dd553e99b.ico",
      }
    ))
    app = Jacks::App.new(app_data)

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

    env = {
      "PATH_INFO" => "/favicon.ico",
    }

    response = app.call(env)

    expect(response[0]).to eq(200)
    expect(response[2]).to eq(["response body"])
  end

  it "proxies files with extensions to the asset proxy" do
    app_data = Jacks::Config::AppData.load
    app = Jacks::App.new(app_data)

    expect(RestClient::Request).to receive(:execute) do |options|
      expect(options[:url]).to eq("http://localhost:5001/app.123abchash.js")
      double(
        code: 200,
        headers: {},
        body: "response body"
      )
    end

    env = {
      "PATH_INFO" => "/app.123abchash.js",
    }

    response = app.call(env)

    expect(response[0]).to eq(200)
    expect(response[2]).to eq(["response body"])
  end

  it "proxies the paths to the right html file" do
    app_data = Jacks::Config::AppData.load
    app_data.manifest = double(
      assets: {
        "index.8b313f72.html" => "index.8b313f72.html",
      }
    )

    app = Jacks::App.new(app_data)

    expect(RestClient::Request).to receive(:execute) do |options|
      expect(options[:url]).to eq("http://localhost:5001/index.8b313f72.html")
      double(
        code: 200,
        headers: {},
        body: "response body"
      )
    end

    env = {
      "PATH_INFO" => "/",
    }

    response = app.call(env)

    expect(response[0]).to eq(200)
    expect(response[2]).to eq(["response body"])
  end

  it "proxies to not found html if the requested path has no html" do
    app_data = Jacks::Config::AppData.load
    app = Jacks::App.new(app_data)

    app_data.manifest = double(
      assets: {
        "index.8b313f72.html" => "index.8b313f72.html",
        "not-found.8b313f72.html" => "not-found.8b313f72.html",
      }
    )

    expect(RestClient::Request).to receive(:execute) do |options|
      expect(options[:url]).to eq(
        "http://localhost:5001/not-found.8b313f72.html"
      )

      double(
        code: 200,
        headers: {},
        body: "response body"
      )
    end

    env = {
      "PATH_INFO" => "/admin/dashboard",
    }

    response = app.call(env)

    expect(response[0]).to eq(200)
    expect(response[2]).to eq(["response body"])
  end

  it "caches proxies in production" do
    app_data = Jacks::Config::AppData.load
    app_data.manifest = double(
      assets: {
        "index.8b313f72.html" => "index.8b313f72.html",
      }
    )
    allow(app_data.environment).to receive(:local?).and_return(false)

    app = Jacks::App.new(app_data)

    expect(RestClient::Request).to receive(:execute).once.and_return(
      double(
        code: 200,
        headers: {},
        body: "response body"
      )
    )

    env = {
      "PATH_INFO" => "/",
    }

    response = app.call(env)
    expect(response[0]).to eq(200)
    expect(response[2]).to eq(["response body"])

    response = app.call(env)
    expect(response[0]).to eq(200)
    expect(response[2]).to eq(["response body"])
  end
end
