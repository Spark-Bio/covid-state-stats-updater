# frozen_string_literal: false

require 'test_helper'

class UpdaterTest < StatsUpdaterTestCase
  def test_span_substitutions
    content = <<~CONTENT
      blah
      <span id="covid-stats-total-cases">4</span><span>unrelated</span>
      other stuff
      again! <span id="covid-stats-total-cases">4</span><span>unrelated</span>
    CONTENT
    result = StatsUpdater::Updater.new.update_stat(
      content, :total_cases, '242,342'
    )

    expected_result = <<~CONTENT
      blah
      <span id="covid-stats-total-cases">242,342</span><span>unrelated</span>
      other stuff
      again! <span id="covid-stats-total-cases">242,342</span><span>unrelated</span>
    CONTENT

    assert_equal expected_result, result
  end

  def test_substitute_initial_placeholder
    content = <<~CONTENT
      blah
      [total_cases]<span>unrelated</span>[other_stuff]
      other stuff
      again! [total_cases]
    CONTENT

    result = StatsUpdater::Updater.new.update_stat(
      content, :total_cases, '242,342'
    )

    expected_result = <<~CONTENT
      blah
      <span id="covid-stats-total-cases">242,342</span><span>unrelated</span>[other_stuff]
      other stuff
      again! <span id="covid-stats-total-cases">242,342</span>
    CONTENT

    assert_equal expected_result, result
  end

  def test_update_content
    content = <<~CONTENT
      <p>Temporary page for API testing.</p>
      <p>Delete before pushing staging to live.</p>
      <p>Total cases in California as of [last_updated]: [total_cases]</p>
    CONTENT

    substitutions = {
      last_updated: 'April 10',
      total_cases: '12,345'
    }

    result = StatsUpdater::Updater.new.update_content(
      content, substitutions
    )

    expected_result = <<~CONTENT
      <p>Temporary page for API testing.</p>
      <p>Delete before pushing staging to live.</p>
      <p>Total cases in California as of <span id="covid-stats-last-updated">April 10</span>: <span id="covid-stats-total-cases">12,345</span></p>
    CONTENT

    assert_equal expected_result, result
  end
end
