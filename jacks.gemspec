require_relative "lib/jacks/version"

Gem::Specification.new do |spec|
  spec.name = "jacks"
  spec.version = Jacks::VERSION
  spec.authors = ["Kane Baccigalupi"]
  spec.email = ["baccigalupi@gmail.com"]

  spec.summary = "A fun to develop, best practices, ruby/js, server/client app"
  spec.description = <<~TEXT
    Working in an app that has both a client side application and a server side
    application is not fun. We keep having to reinvent this world where one app
    passes through to the other, and static assets are truly static. Jacks is a Rack
    server that passes through to a React client side app. It is backed by webpack.
    Assets deploy to S3. Just add application and love.
  TEXT
  spec.homepage = "https://github.com/baccigalupi/jacks"
  spec.license = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  # spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "dotenv", "~> 2.7"
  spec.add_runtime_dependency "mime-types", "~> 3.3"
  spec.add_runtime_dependency "puma", "~> 4.3"
  spec.add_runtime_dependency "rack", "~> 2.0"
  spec.add_runtime_dependency "rake", "~> 13.0"
  spec.add_runtime_dependency "rest-client", "~> 2.1"

  spec.add_runtime_dependency "pg", "~> 1.1"
  spec.add_runtime_dependency "sequel", "~> 5.27"

  spec.add_runtime_dependency "jwt", "~> 2.2"
  spec.add_runtime_dependency "omniauth", "~> 1.9"

  spec.add_runtime_dependency "aws-sdk-s3", "~> 1.59"
end
