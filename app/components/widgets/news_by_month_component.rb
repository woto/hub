# frozen_string_literal: true

module Widgets
  class NewsByMonthComponent < ViewComponent::Base
    def initialize
      client = Elasticsearch::Client.new Rails.application.config.elastic
      @result = client.search(
        index: Elastic::IndexName.posts,
        body: {
          "size": 0,
          "aggs": {
            "group_by_month": {
              "date_histogram": {
                "field": 'created_at',
                "calendar_interval": 'month',
                "order": { "_key": 'desc' }
              }
            }
          }
        }
      )
    end
  end
end
