# frozen_string_literal: true

require 'active_support'
require 'active_support/number_helper/number_to_delimited_converter'

module StatsUpdater
  class Updater
    # TEMPORARY
    SLUG_PREFIX = 'api-test-page-neil'

    DATE_FORMAT = '%B %d'

    def update_stats
      pages = word_press.pages_with_slug_prefix(SLUG_PREFIX)
      state_stats.values.each do |stats_for_state|
        key = stats_for_state.state_name.downcase
        page = pages[key]
        next unless page

        new_content = update_content(
          page.content.rendered,
          substitutions(stats_for_state)
        )

        word_press.update_page_content(page.id, new_content)
      end

      true
    end

    def substitutions(stats_for_state)
      {
        last_updated: stats_for_state.date_checked.strftime(DATE_FORMAT),
        total_cases: delimit_number(stats_for_state.total)
      }
    end

    def update_content(source, substitutions)
      substitutions.inject(source) do |content, (key, value)|
        content = update_stat(content, key, value)
      end
    end

    def update_stat(source, key, value)
      result = source

      result = substitute_existing_values(result, key, value)
      result = substitute_initial_placeholder(result, key, value)

      result
    end

    # Handle the case of a page where the content has already
    # been updated at least once. In thise case we'll have one or more
    # a span tag with a specific ID we can search for.
    def substitute_existing_values(source, key, value)
      matches = source.scan(span_regex(key)).flatten.uniq

      new_value = new_value(key, value)

      matches.each_with_object(source.clone) do |match, acc|
        acc = acc.gsub!(match, new_value)
      end
    end

    # Handle the case of the initial variable, which is the
    # name of the stat in square braces
    def substitute_initial_placeholder(source, key, value)
      source.gsub("[#{key}]", new_value(key, value))
    end

    def new_value(key, value)
      [stat_span_open(key), value.to_s, stat_span_close].reduce(:+)
    end

    def span_regex(key)
      Regexp.new(
        ['(?<old_value>', stat_span_open(key), '.*?', stat_span_close, ')'].reduce(:+)
      )
    end

    def stat_span_open(key)
      dashed_key = key.to_s.gsub('_', '-')
      "<span id=\"covid-stats-#{dashed_key}\">"
    end

    def stat_span_close
      '</span>'
    end

    def delimit_number(number)
      ActiveSupport::NumberHelper::NumberToDelimitedConverter.convert(number, {})
    end

    def state_stats
      @state_stats ||= covid_stats.state_stats
    end

    def word_press
      @word_press ||= WordPress.new
    end

    def covid_stats
      @covid_stats ||= COVIDTracking.new
    end
  end
end
