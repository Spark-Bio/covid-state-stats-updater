# COVID-19 Stats Updater

Script for updating the [COVID-19 Testing Site](https://spark-bio.com/) with current state-level stats.

## Usage

This will update set of WordPress pages with a given "slug prefix" followed by a state name, for example if the "slug prefix" is `test-sites` it will expect pages to be named

* `test-sites-california`
* `test-sites-rhode-island`

etc.

It supports substituting placeholders with values. Currently supported values are:

| Placeholder       | Value                                  |
|-------------------|----------------------------------------|
| `[last_updated]`  | Date of last update e.g. `April 3`.    |
| `[total_cases]`   | Total cases in the state e.g. `10,056` |

The initial placeholder tag is substituted with a value including a `span` tag with its `id` attribute set so that we can easily identify the value and update it after the initial substitution. Example:

`<span id="covid-stats-total-cases">10,056</span>`

It's important that the `span` tags are left intact when editing the page.

## Data Sources

Data comes from the [COVID Tracking Project API](https://covidtracking.com/api).

[Other values from the API](https://covidtracking.com/api#apistates---states-current-values) can easily be added.

## Developer Instructions

### Setup

* [Install `rbenv`](https://github.com/rbenv/rbenv#installation)
* Install the specified ruby version: ``rbenv install `cat .ruby-version` ``
* Install `bundler`: `gem install bundler`
* Install dependencies `bundle install`
* Obtain a staging WordPress account and set up the following env. vars:
  * `COVID_WP_USER="<username>"`
  * `COVID_WP_PASSWORD="<password>"`
  * `COVID_WP_ENV="staging"`

### Updating dependencies

When pulling the latest from github, if `Gemfile.lock` has been updated, run `bundle update`.

### Running tests

`bundle exec rake test`

### Running rake tasks

```
$ bundle exec rake stats
Alabama:
  Last checked: Sun, 12 Apr 2020 02:51:00 +0000
  Hospitalized: 402
  Recovered:
  Deaths: 93
Alaska:
[...]
```

### Running locally in irb

```
12:00:00 (master)$ bundle exec irb
irb(main):001:0> load 'lib/stats_updater.rb'
=> true
irb(main):002:0> StatsUpdater::WordPress.new.pages.size
=> 10
```

## Overview

The state-specific pages which will include some some statistics from the [COVID Tracking Project](https://covidtracking.com/api) and Johns Hopkins.

The intention is to periodically run task that periodically that pulls the data down from the APIs, uses the WordPress API to pull in the content for each state page, substitutes in the new stats, and writes them back.
