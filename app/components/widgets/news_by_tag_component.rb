# frozen_string_literal: true

module Widgets
  class NewsByTagComponent < ViewComponent::Base
    def initialize(*)
      client = Elasticsearch::Client.new Rails.application.config.elastic
      @result = client.search(
        index: Elastic::IndexName.posts,
        body: {
          "size": 0,
          "aggs": {
            "group_by_tag": {
              "terms": { "field": 'tags.keyword' }
            }
          }
        }
      )
    end
  end
end
