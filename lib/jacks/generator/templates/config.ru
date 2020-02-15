# frozen_string_literal: true

$stdout.sync = true
$stderr.sync = true

require_relative "./app"

run Config::RackApp.new.config
