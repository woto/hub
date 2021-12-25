# frozen_string_literal: true

module Indexing
  class BingJob < ApplicationJob
    include Rails.application.routes.url_helpers

    def perform(url:)
      conn = Faraday.new do |faraday|
        faraday.use FaradayMiddleware::FollowRedirects
        faraday.adapter Faraday.default_adapter
        faraday.response :raise_error
        faraday.request :json
        faraday.response :json
      end

      begin
        conn.get('https://www.bing.com/indexnow', {
                   url: url,
                   key: ENV.fetch('INDEX_NOW_KEY'),
                   keyLocation: index_now_url(host: ENV['DOMAIN_NAME'], protocol: 'https')
                 })
      rescue Faraday::Error => e
        Rails.logger.error(status: e.response_status)
        Rails.logger.error(body: e.response_body)
        raise
      end
    end
  end
end
