# frozen_string_literal: true

require "spec_helper"

RSpec.describe Jacks::Config::AppData::Sequel do
  it "decorates both itself and a db connection on to the data object" do
    data = Jacks::Config::AppData.load
    expect(data.sequel).to be_a(Jacks::Config::AppData::Sequel)
    expect(data.db).to be_a(Sequel::Postgres::Database)
  end

  it "defaults to a DATABASE_URL envar" do
    environment = double(
      app_env: "test",
      env_vars: {
        "DATABASE_URL" =>
          "postgres://foo:bar@somelong.awshost:1234/mydatabaseurl",
      }
    )
    logger = double

    data = double(environment: environment, logger: logger)

    connector = Jacks::Config::AppData::Sequel.new(data)

    expect(connector.url).to eq(
      "postgres://foo:bar@somelong.awshost:1234/mydatabaseurl"
    )
  end

  it "generates a default local connection url without envars" do
    environment = double(
      app_env: "test",
      env_vars: {}
    )

    logger = double

    data = double(environment: environment, logger: logger)

    connector = Jacks::Config::AppData::Sequel.new(data)

    expect(connector.url).to match(%r{postgres://.+@localhost:5432/dykaspora_test})
  end

  it "uses custom envars when no database url is present, but they are" do
    environment = double(
      app_env: "test",
      env_vars: {
        "DATABASE_USER" => "jacks",
        "DATABASE_PASSWORD" => "play",
        "DATABASE_HOST" => "123.234.45.67",
        "DATABASE_PORT" => "1234",
      }
    )

    logger = double

    data = double(environment: environment, logger: logger)

    connector = Jacks::Config::AppData::Sequel.new(data)

    expect(connector.url).to eq(
      "postgres://jacks:play@123.234.45.67:1234/dykaspora_test"
    )
  end
end
