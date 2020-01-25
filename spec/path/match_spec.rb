# frozen_string_literal: true

require "spec_helper"

RSpec.describe Jacks::Path::Match do
  describe "#match?" do
    it "both paths are the same is true" do
      expect(Jacks::Path::Match.new(
        "/foo/bar",
        "/foo/bar"
      )).to be_match

      expect(Jacks::Path::Match.new(
        "/",
        "/"
      )).to be_match
    end

    it "when paths don't match is false" do
      expect(Jacks::Path::Match.new(
        "/foo/baz",
        "/foo/bar"
      )).not_to be_match
    end

    it "when paths don't match and are of different lengths it is false" do
      expect(Jacks::Path::Match.new(
        "/foo",
        "/"
      )).not_to be_match

      expect(Jacks::Path::Match.new(
        "/",
        "/foo"
      )).not_to be_match
    end

    it "when there are embedded params in one, but otherwise matches will be true" do
      expect(Jacks::Path::Match.new(
        "/:page_name",
        "/pricing"
      )).to be_match

      expect(Jacks::Path::Match.new(
        "/thing/:id/thang/:thang_id",
        "/thing/123/thang/456"
      )).to be_match
    end

    it "is false when both sides have a param key" do
      expect(Jacks::Path::Match.new(
        "/:page_name",
        "/:pricing"
      )).not_to be_match
    end

    it "is false when param key doesn't match" do
      expect(Jacks::Path::Match.new(
        "/foo/:page_name",
        "/foo/"
      )).not_to be_match
    end

    it "is true when globbing the end of an otherwise matching path" do
      expect(Jacks::Path::Match.new(
        "/about/*page_path",
        "/about/pricing/buy-now"
      )).to be_match

      expect(Jacks::Path::Match.new(
        "/about/pricing/buy-now",
        "/about/*page_path"
      )).to be_match
    end

    it "is false when glob doesn't match" do
      expect(Jacks::Path::Match.new(
        "/about/*page_path",
        "/about"
      )).not_to be_match

      expect(Jacks::Path::Match.new(
        "/about",
        "/about/*page_path"
      )).not_to be_match

      expect(Jacks::Path::Match.new(
        "/about/*page_path",
        "/"
      )).not_to be_match
    end

    it "is false when both sides have a glob" do
      expect(Jacks::Path::Match.new(
        "/about/*page_path",
        "/about/*foo"
      )).not_to be_match
    end
  end

  describe "#params" do
    it "is an empty hash when a match without params or globs" do
      expect(
        Jacks::Path::Match.new(
          "/foo/bar",
          "/foo/bar"
        ).params
      ).to eq({})

      expect(
        Jacks::Path::Match.new(
          "/",
          "/"
        ).params
      ).to eq({})
    end

    it "is an empty hash when the paths don't match" do
      expect(
        Jacks::Path::Match.new(
          "/foo/baz",
          "/foo/bar"
        ).params
      ).to eq({})
    end

    it "when there are embedded params in one, but otherwise matches will be true" do
      expect(
        Jacks::Path::Match.new(
          "/:page_name",
          "/pricing"
        ).params
      ).to eq("page_name" => "pricing")

      expect(
        Jacks::Path::Match.new(
          "/thing/:id/thang/:thang_id",
          "/thing/123/thang/456"
        ).params
      ).to eq(
        "id" => "123",
        "thang_id" => "456"
      )
    end

    it "is true when globbing the end of an otherwise matching path" do
      expect(
        Jacks::Path::Match.new(
          "/about/*page_path",
          "/about/pricing/buy-now"
        ).params
      ).to eq(
        "page_path" => "pricing/buy-now"
      )
    end
  end
end
