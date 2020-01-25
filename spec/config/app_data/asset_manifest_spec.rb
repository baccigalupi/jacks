# frozen_string_literal: true

require "spec_helper"

RSpec.describe Jacks::Config::AppData::AssetManifest do
  it "adds a manifest attribute on to the data" do
    data = Jacks::Config::AppData.load
    expect(data.manifest).to be_a(Jacks::Config::AppData::AssetManifest)
  end

  it "loads assets from the local when environment is local" do
    data = OpenStruct.new(
      environment: double(
        local?: true,
        development?: true
      ),
      root: root
    )

    Jacks::Config::AppData::AssetManifest.decorate(data)

    expect(data.manifest.assets).to eq(local_manifest)
  end

  it "loads assets from the production manifest when environment is not" do
    data = OpenStruct.new(
      environment: double(
        local?: false,
        development?: false
      ),
      root: root
    )

    Jacks::Config::AppData::AssetManifest.decorate(data)

    expect(data.manifest.assets).to eq(production_manifest)
  end

  it "caches the manifest when in production" do
    data = OpenStruct.new(app_env: "production", root: root)
    Jacks::Config::AppData::Environment.decorate(data)
    Jacks::Config::AppData::AssetManifest.decorate(data)

    data.manifest.assets

    expect(JSON).not_to receive(:parse)

    data.manifest.assets
  end

  it "caches the manifest when in test" do
    data = OpenStruct.new(app_env: "test", root: root)
    Jacks::Config::AppData::Environment.decorate(data)
    Jacks::Config::AppData::AssetManifest.decorate(data)

    data.manifest.assets

    expect(JSON).not_to receive(:parse)

    data.manifest.assets
  end

  it "does not cache the mainfest when in devopment" do
    data = OpenStruct.new(app_env: "development", root: root)
    Jacks::Config::AppData::Environment.decorate(data)
    Jacks::Config::AppData::AssetManifest.decorate(data)

    data.manifest.assets

    expect(JSON).to receive(:parse)

    data.manifest.assets
  end

  it "warns and returns an empty hash if unable to find the manifest" do
    data = OpenStruct.new(app_env: "development", root: "/tmp")
    Jacks::Config::AppData::Environment.decorate(data)
    Jacks::Config::AppData::AssetManifest.decorate(data)

    expect(Warning).to receive(:warn)
    expect(data.manifest.assets).to eq({})
  end

  def load_file(name = "")
    File.expand_path(File.join(
      root, "app/client/manifest#{name}.json"
    ))
  end

  def root
    File.expand_path(File.join(__dir__, "../../support/fixtures"))
  end

  def local_manifest
    JSON.parse(File.read(load_file(".local")))
  end

  def production_manifest
    JSON.parse(File.read(load_file))
  end
end
