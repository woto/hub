# frozen_string_literal: true

module Dashboard
  class LatestNewsComponent < ViewComponent::Base
    def initialize
      client = Elasticsearch::Client.new Rails.application.config.elastic
      result = client.search(
        Widgets::NewsSearchQuery.call(
          code: :help,
          locale: I18n.locale,
          sort: :published_at,
          order: :desc,
          from: 0,
          size: 1
        ).object
      )

      @news = result.dig('hits', 'hits', 0, '_source')
    end
  end
end
