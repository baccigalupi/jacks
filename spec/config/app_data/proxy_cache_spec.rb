# frozen_string_literal: true

require "spec_helper"

RSpec.describe Jacks::Config::AppData::ProxyCache do
  it "adds a proxy_cache attribute on to the data" do
    data = Jacks::Config::AppData.load
    expect(data.proxy_cache).to be_a(Jacks::Config::AppData::ProxyCache)
  end

  it "#exist? is true if the key is present" do
    data = OpenStruct.new(app_env: "production")
    Jacks::Config::AppData::Environment.decorate(data)
    Jacks::Config::AppData::ProxyCache.decorate(data)

    cache = data.proxy_cache
    cache.set("foo", [200, {}, ["my-foo"]])
    expect(cache.exist?("foo")).to be(true)
  end

  it "#exist? is false if the key has not been set" do
    data = OpenStruct.new(app_env: "production")
    Jacks::Config::AppData::Environment.decorate(data)
    Jacks::Config::AppData::ProxyCache.decorate(data)

    cache = data.proxy_cache
    expect(cache.exist?("foo")).to be(false)
  end

  it "#exist? is false when environment is local" do
    data = OpenStruct.new(app_env: "development")
    Jacks::Config::AppData::Environment.decorate(data)
    Jacks::Config::AppData::ProxyCache.decorate(data)

    cache = data.proxy_cache
    cache.set("foo", [200, {}, ["my-foo"]])
    expect(cache.exist?("foo")).to be(false)
  end

  it "#set works with #get to cache a key/value" do
    data = OpenStruct.new(app_env: "production")
    Jacks::Config::AppData::Environment.decorate(data)
    Jacks::Config::AppData::ProxyCache.decorate(data)

    cache = data.proxy_cache
    cache.set("foo", [200, {}, ["my-foo"]])
    expect(cache.get("foo")).to eq([200, {}, ["my-foo"]])
  end

  it "#set will not cache if the status is a fail" do
    data = OpenStruct.new(app_env: "production")
    Jacks::Config::AppData::Environment.decorate(data)
    Jacks::Config::AppData::ProxyCache.decorate(data)

    cache = data.proxy_cache
    cache.set("foo", [404, {}, ["my-foo"]])
    expect(cache.exist?("foo")).to eq(false)
  end
end
