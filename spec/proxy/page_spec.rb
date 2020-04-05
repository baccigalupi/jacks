# frozen_string_literal: true

require "spec_helper"

RSpec.describe Jacks::Proxy::Page do
  it "maps the root path to an index path" do
    manifest = {
      "index.8b313f72.html" => "index.8b313f72.html",
    }
    path = "/"

    finder = Jacks::Proxy::Page.new(path, manifest)

    expect(finder.matching_page).to eq("/index.8b313f72.html")
  end

  it "maps nested pages to non-index page html if available" do
    manifest = {
      "admin/dashboard.8b313f72.html" => "admin/dashboard.8b313f72.html",
    }
    path = "/admin/dashboard"

    finder = Jacks::Proxy::Page.new(path, manifest)

    expect(finder.matching_page).to eq("/admin/dashboard.8b313f72.html")
  end

  it "maps nested pages to the nested index html" do
    manifest = {
      "admin/dashboard/index.8b313f72.html" =>
        "admin/dashboard/index.8b313f72.html",
    }
    path = "/admin/dashboard"

    finder = Jacks::Proxy::Page.new(path, manifest)

    expect(finder.matching_page).to eq("/admin/dashboard/index.8b313f72.html")
  end

  it "returns a not found page with no match, if the manifest contains one" do
    manifest = {
      "not-found.8b313f72.html" => "not-found.8b313f72.html",
      "error.8b313f72.html" => "error.8b313f72.html",
    }
    path = "/admin/dashboard"

    finder = Jacks::Proxy::Page.new(path, manifest)

    expect(finder.matching_page).to eq("/not-found.8b313f72.html")
  end

  it "returns a hashed error page with no match" do
    manifest = {
      "error.8b313f72.html" => "error.8b313f72.html",
    }
    path = "/admin/dashboard"

    finder = Jacks::Proxy::Page.new(path, manifest)

    expect(finder.matching_page).to eq("/error.8b313f72.html")
  end

  it "returns the default error page with no match" do
    manifest = {}
    path = "/admin/dashboard"

    finder = Jacks::Proxy::Page.new(path, manifest)

    expect(finder.matching_page).to eq("/error.html")
  end

  it "maps full nesting instead of partial nesting" do
    manifest = {
      "admin/dashboard/index.8b313f72.html" =>
        "admin/dashboard/index.8b313f72.html",
    }
    path = "/dashboard"

    finder = Jacks::Proxy::Page.new(path, manifest)

    expect(finder.matching_page).to eq("/error.html")
  end
end
