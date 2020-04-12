# frozen_string_literal: true

# Include our application
$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
load 'stats_updater.rb' unless defined?(StatsUpdater)

require 'minitest/autorun'

class StatsUpdaterTestCase < Minitest::Test
end
