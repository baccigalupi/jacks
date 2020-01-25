# frozen_string_literal: true

require "spec_helper"

RSpec.describe Jacks::App::DataDecorator do
  it "adds itself to a susceptible bundle of app data" do
    class NewConfiguryThingy < Jacks::App::DataDecorator
      def name
        "configury_thingy"
      end

      def is_new_configury?
        true
      end
    end

    data = OpenStruct.new
    NewConfiguryThingy.decorate(data)

    expect(data.configury_thingy).to be_a(NewConfiguryThingy)
    expect(data.configury_thingy.is_new_configury?).to eq(true)
  end
end
