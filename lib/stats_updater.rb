# frozen_string_literal: true

$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'stats_updater/no_warning_mash'
require 'stats_updater/api_client'
require 'stats_updater/covid_tracking'
require 'stats_updater/word_press'
require 'stats_updater/updater'

# Module for updating the Covid website with state-specifi
# stats.
module StatsUpdater
  VERSION ||= '0.1.0'

  def self.logger
    @logger ||= Logger.new(STDOUT)
    @logger.level = ENV['LOG_LEVEL'].blank? ? Logger::ERROR : ENV['LOG_LEVEL']
    @logger
  end
end
