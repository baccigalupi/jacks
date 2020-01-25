# frozen_string_literal: true

require "spec_helper"

RSpec.describe Jacks::Request::TypeHandler::Json do
  it ".match? will be true for json requests" do
    request = double("request", json?: true)
    expect(Jacks::Request::TypeHandler::Json.match?(request)).to eq(true)
  end

  it ".match? will be false for non-json requests" do
    request = double("request", json?: false)
    expect(Jacks::Request::TypeHandler::Json.match?(request)).to eq(false)
  end

  it "#call will run the action for a matching route" do
    action = double("action",
      call: [
        200, {}, [{hello: "world"}.to_json],
      ])
    allow(action).to receive(:new).and_return(action)

    app_data = Jacks::Config::AppData.load
    allow(app_data.environment).to receive(:catch_errors?).and_return(true)
    allow(app_data).to receive(:routes).and_return([
      Jacks::Route.new("GET", "/foo/:id", action),
    ])

    env = {
      "PATH_INFO" => "/foo/bar",
      "REQUEST_METHOD" => "GET",
      "CONTENT_TYPE" => "application/json",
    }

    request = Jacks::Request::Data.new(env)

    json_handler = Jacks::Request::TypeHandler::Json.new(request, app_data)
    response = json_handler.call

    expect(response[0]).to eq(200)
    expect(response[2]).to eq([{hello: "world"}.to_json])
  end

  it '#call matches routes that end with a ".json"' do
    action = double("action",
      call: [
        200, {}, [{hello: "world"}.to_json],
      ])
    allow(action).to receive(:new).and_return(action)

    app_data = Jacks::Config::AppData.load
    allow(app_data.environment).to receive(:catch_errors?).and_return(true)
    allow(app_data).to receive(:routes).and_return([
      Jacks::Route.new("GET", "/overview", action),
    ])

    env = {
      "PATH_INFO" => "/overview.json",
      "REQUEST_METHOD" => "GET",
      "CONTENT_TYPE" => "application/json",
    }

    request = Jacks::Request::Data.new(env)

    json_handler = Jacks::Request::TypeHandler::Json.new(request, app_data)
    response = json_handler.call

    expect(response[0]).to eq(200)
    expect(response[2]).to eq([{hello: "world"}.to_json])
  end

  it "#call will return a 404 response if route is not found" do
    action = double("action",
      call: [
        200, {}, [{hello: "world"}.to_json],
      ])
    allow(action).to receive(:new).and_return(action)

    app_data = Jacks::Config::AppData.load
    allow(app_data).to receive(:routes).and_return([
      Jacks::Route.new("GET", "/foo/:id", action),
    ])

    env = {
      "PATH_INFO" => "/bar/foo",
      "REQUEST_METHOD" => "GET",
      "CONTENT_TYPE" => "application/json",
    }

    request = Jacks::Request::Data.new(env)

    json_handler = Jacks::Request::TypeHandler::Json.new(request, app_data)
    response = json_handler.call

    expect(response[0]).to eq(404)
    expect(response[2][0]).to include("Not found")
  end

  it "#call will allow an error to be raised in non-production environments" do
    action = double("action")
    allow(action).to receive(:new).and_return(action)
    expect(action).to receive(:call).and_raise(NameError)

    app_data = Jacks::Config::AppData.load
    allow(app_data).to receive(:routes).and_return([
      Jacks::Route.new("GET", "/foo/:id", action),
    ])

    env = {
      "PATH_INFO" => "/foo/123",
      "REQUEST_METHOD" => "GET",
      "CONTENT_TYPE" => "application/json",
    }

    request = Jacks::Request::Data.new(env)

    json_handler = Jacks::Request::TypeHandler::Json.new(request, app_data)
    expect { json_handler.call }.to raise_error(NameError)
  end

  it "#call will catch errors and return an error message in production" do
    action = double("action")
    allow(action).to receive(:new).and_return(action)
    expect(action).to receive(:call).and_raise(
      NameError.new("Danger, Will Robinson")
    )

    app_data = Jacks::Config::AppData.load
    allow(app_data.environment).to receive(:catch_errors?).and_return(true)
    allow(app_data).to receive(:routes).and_return([
      Jacks::Route.new("GET", "/foo/:id", action),
    ])

    env = {
      "PATH_INFO" => "/foo/123",
      "REQUEST_METHOD" => "GET",
      "CONTENT_TYPE" => "application/json",
    }

    request = Jacks::Request::Data.new(env)

    json_handler = Jacks::Request::TypeHandler::Json.new(request, app_data)
    response = json_handler.call

    expect(response[0]).to eq(500)
    expect(response[2][0]).to include("Danger, Will Robinson")
  end
end
