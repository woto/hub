# frozen_string_literal: true

module Indexing
  class YandexJob < ApplicationJob
    include Rails.application.routes.url_helpers

    def perform(url:)
      conn = Faraday.new do |faraday|
        faraday.adapter Faraday.default_adapter
        faraday.response :follow_redirects
        faraday.response :raise_error
        faraday.request :json
        faraday.response :json
      end

      begin
        conn.get('https://yandex.com/indexnow', {
                   url:,
                   key: ENV.fetch('INDEX_NOW_KEY'),
                   keyLocation: index_now_url(host: GlobalHelper.host)
                 })
      rescue Faraday::Error => e
        Rails.logger.error(e)
        raise
      end
    end
  end
end
