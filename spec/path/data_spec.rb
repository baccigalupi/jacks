# frozen_string_literal: true

require "spec_helper"

RSpec.describe Jacks::Path::Data do
  describe "#collection" do
    it 'is an empty array when path is "/"' do
      expect(Jacks::Path::Data.new("/").collection).to eq([])
    end

    it "separates on slashes" do
      expect(Jacks::Path::Data.new("/foo/bar").collection).to eq([
        "foo", "bar",
      ])
    end
  end
end
