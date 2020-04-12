# frozen_string_literal: true

require 'hashie'

module StatsUpdater
  class NoWarningMash < Hashie::Mash
    disable_warnings
  end
end
