# frozen_string_literal: true

module Interactors
  module Topics
    class Elasticsearch
      include ApplicationInteractor

      contract do
        params do
          config.validate_keys = true
          required(:q).maybe(:string)
        end
      end

      def call
        query = TopicsSearchQuery.call(
          q: context.q,
          sort: 'topics_relations_count',
          order: 'desc',
          from: 0,
          size: 20
        ).object

        result = GlobalHelper.elastic_client.search(query)

        context.object = result['hits']['hits'].map do |topic|
          {
            id: topic['_source']['id'],
            title: topic['_source']['title'],
            count: topic['_source']['topics_relations_count']
          }
        end
      end
    end
  end
end
