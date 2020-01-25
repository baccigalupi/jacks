# frozen_string_literal: true

require "spec_helper"

RSpec.describe Jacks::Request::Data do
  it "allows get methods to be overriden by other methods" do
    env = {
      "REQUEST_METHOD" => "GET",
      "QUERY_STRING" => "_method=delete",
    }

    expect(Jacks::Request::Data.new(env).method).to eq("DELETE")
  end

  it "has params pulled from the query string" do
    env = {
      "QUERY_STRING" => "foo=bar&key=value&this=that",
    }

    expect(Jacks::Request::Data.new(env).params).to eq(
      "foo" => "bar",
      "key" => "value",
      "this" => "that"
    )
  end

  it "determines content type based on the env" do
    env = {
      "HTTP_ACCEPT" => nil,
      "CONTENT_TYPE" => "application/json",
    }

    expect(Jacks::Request::Data.new(env).content_type).to eq("json")
  end

  it "determines content type based on the env" do
    env = {
      "CONTENT_TYPE" => "application/json",
    }

    expect(Jacks::Request::Data.new(env).content_type).to eq("json")
  end

  it "defaults to html content type when no content present" do
    env = {
      "CONTENT_TYPE" => nil,
    }

    expect(Jacks::Request::Data.new(env).content_type).to eq("html")
  end

  it "will have content_type json if that file type is requested" do
    env = {
      "PATH_INFO" => "thing.json",
    }

    expect(Jacks::Request::Data.new(env).content_type).to eq("json")
  end

  it "#static? will be false if it is a json request" do
    env = {
      "CONTENT_TYPE" => "application/json",
      "PATH_INFO" => "/thing.js",
    }

    expect(Jacks::Request::Data.new(env).static?).to eq(false)
  end

  it "#static? will be true if it has a file extension" do
    env = {
      "PATH_INFO" => "/thing.js",
    }

    expect(Jacks::Request::Data.new(env).static?).to eq(true)
  end

  it "#static? will be false without a file extension" do
    env = {
      "PATH_INFO" => "/thing",
    }

    expect(Jacks::Request::Data.new(env).static?).to eq(false)
  end
end
