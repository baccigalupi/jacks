# frozen_string_literal: true

require "spec_helper"

RSpec.describe Jacks::Config::AppData::JsonRoutes do
  it "adds a routes array to the data" do
    data = Jacks::Config::AppData.load
    expect(data.routes).to be_a(Array)
    # expect(data.routes.first).to be_a(Jacks::Route)
  end
end
