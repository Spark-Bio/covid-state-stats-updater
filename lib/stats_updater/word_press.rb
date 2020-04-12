# frozen_string_literal: true

require 'faraday'
require 'faraday/detailed_logger'
require 'faraday_middleware'

module StatsUpdater
  # See: https://developer.wordpress.org/rest-api/reference/#rest-api-developer-endpoint-reference
  class WordPress < APIClient
    DETAILED_LOGGING = ENV['WP_API_DEBUG'] == 'true'

    WP_HOST =
      case ENV['COVID_WP_ENV']
      when 'staging'
        'staging-sparkbiocom.kinsta.cloud'
      when 'production'
        'staging-sparkbiocom.kinsta.cloud'
      else
        raise ArgumentError, 'COVID_WP_ENV env. var. must be set to "staging" or "production"'
      end
    WP_ENDPOINT = "https://#{WP_HOST}/wp-json/wp/v2"

    WP_USERNAME = ENV['COVID_WP_USER']
    WP_PASSWORD = ENV['COVID_WP_PASSWORD']

    def conn
      super(WP_ENDPOINT) do |conn|
        # TODO: move away from basic auth, at least for production. See:
        # https://developer.wordpress.org/rest-api/using-the-rest-api/authentication/#authentication-plugins
        #
        # Also see how it was implemented in this library:
        # https://github.com/duncanjbrown/wp-api-client/blob/master/lib/wp_api_client/connection.rb#L18-L24
        # (I didn't use this because it seems unmaintained, and it's read-only)
        #
        # I think we'd need to install this plugin on our server:
        # https://wordpress.org/plugins/rest-api-oauth1/

        conn.basic_auth(WP_USERNAME, WP_PASSWORD)
      end
    end

    def pages
      get('pages', 'fetching pages')
    end

    def posts
      get('posts', 'fetching posts')
    end

    def post_types
      get('types', 'fetching post types')
    end

    def page(slug)
      pages.find { |page| page.slug == slug }
    end

    def pages_with_slug_prefix(slug_prefix)
      regexp = Regexp.new("^#{slug_prefix}-(?<suffix>.+)$", Regexp::IGNORECASE)
      matching_pages = pages.find_all { |page| page.slug =~ regexp }
      matching_pages.each_with_object({}) do |page, acc|
        unique_part = page.slug.scan(regexp).flatten.first
        acc[unique_part] = page
      end
    end

    # see: https://developer.wordpress.org/rest-api/reference/pages/#update-a-page
    def update_page_content(page_id, new_content)
      post("pages/#{page_id}", { content: new_content }, 'update page')
    end
  end
end
