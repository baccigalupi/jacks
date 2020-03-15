require "fileutils"

module Jacks
  class Generator
    attr_reader :root

    def self.call(path)
      new(path).call
    end

    def initialize(path)
      path = "#{Dir.pwd}/#{path}" unless path.start_with?("/")
      @root = File.expand_path(path)
    end

    def name
      root.split("/").last
    end

    def call
      make_root
      copy_templates
      enable_gitignore
      replace_name_in_app
    end

    def make_root
      FileUtils.mkdir_p(root)
    end

    def copy_templates
      Dir.glob(templates_dir) do |filename|
        FileUtils.copy_entry(filename, root)
      end
    end

    def templates_dir
      File.expand_path(__dir__ + "/generator/templates")
    end

    def enable_gitignore
      FileUtils.mv("#{root}/gitignore", "#{root}/.gitignore")
    end

    def replace_name_in_app
      File.open("#{root}/.ruby-gemset", "w") do |file|
        file.write(name)
      end

      sequel_contents = File.read("#{root}/app/config/app_data/sequel.rb")
      sequel_contents = sequel_contents.gsub("jacks_app", name)
      File.open("#{root}/app/config/app_data/sequel.rb", "w") do |file|
        file.write(sequel_contents)
      end
    end
  end
end
