# frozen_string_literal: true

require "spec_helper"

RSpec.describe Jacks::Config::AppData::Logger do
  it 'decorates a ::Logger on to the data bag as "logger"' do
    data = OpenStruct.new(
      environment: double(
        log_to_file?: true,
        local?: true,
        app_env: "test"
      ),
      root_dir: File.expand_path(__dir__ + "/../../support/fixtures")
    )

    Jacks::Config::AppData::Logger.decorate(data)

    expect(data.logger).to be_a(::Logger)
  end
end
