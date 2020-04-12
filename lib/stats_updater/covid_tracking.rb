# frozen_string_literal: true

require 'carmen'

module StatsUpdater
  # Client for: https://covidtracking.com/api
  class COVIDTracking < APIClient
    ENDPOINT = 'https://covidtracking.com/api/v1'

    def conn
      super(ENDPOINT)
    end

    def state_stats
      raw_results = get('states/current.json', 'fetching state stats')

      raw_results.each_with_object(NoWarningMash.new) do |state_entry, acc|
        state = us.subregions.coded(state_entry.state)
        state_entry.state_name = state.name
        state_entry.date_checked = DateTime.parse(state_entry.dateChecked)
        acc[state_entry.state.downcase] = state_entry
      end
    end

    def summary
      summaries = state_stats.values.sort_by(&:state_name).map do |state_stats|
        "#{state_stats.state_name}:\n" \
        "  Last checked: #{state_stats.date_checked.rfc822}\n" \
        "  Hospitalized: #{state_stats.hospitalized}\n" \
        "  Recovered: #{state_stats.recovered}\n" \
        "  Deaths: #{state_stats.death}"
      end
      summaries.join("\n")
    end

    def us
      @us ||= Carmen::Country.named('United States')
    end
  end
end
