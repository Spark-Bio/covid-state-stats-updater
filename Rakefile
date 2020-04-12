# frozen_string_literal: true

task :pages do
  load 'lib/stats_updater.rb' unless defined?(StatsUpdater)
  puts StatsUpdater::WordPress.new.pages.map(&:slug).join("\n")
end

task :posts do
  load 'lib/stats_updater.rb' unless defined?(StatsUpdater)
  puts StatsUpdater::WordPress.new.posts.map(&:slug).join("\n")
end

task :post_types do
  load 'lib/stats_updater.rb' unless defined?(StatsUpdater)
  pp StatsUpdater::WordPress.new.post_types
end

task :stats do
  load 'lib/stats_updater.rb' unless defined?(StatsUpdater)
  puts StatsUpdater::COVIDTracking.new.summary
end

task :update_stats do
  load 'lib/stats_updater.rb' unless defined?(StatsUpdater)
  puts StatsUpdater::Updater.new.update_stats
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/unit/**/*_test.rb'
  test.warning = false
end

Rake::TestTask.new(:integration) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/integration/*_test.rb'
  test.warning = false
end
