# frozen_string_literal: true

module Entities
  class RelatedInteractor
    include ApplicationInteractor

    contract do
      params do
        optional(:entity_ids)
        optional(:entities_search_string)
        optional(:mentions_search_string)
      end
    end

    def call
      query = RelatedQuery.call(
        entity_ids: context.entity_ids,
        mentions_search_string: context.mentions_search_string,
        entities_search_string: context.entities_search_string,
        size: 50
      ).object

      # puts JSON.pretty_generate(query)

      grouped_entities = GlobalHelper.elastic_client.search(query).then do |res|
        res['aggregations']['group']['group']['group']['buckets'].map do |bucket|
          {
            entity_id: bucket['key'],
            count: bucket['doc_count']
          }
        end
      end

      query = IndexQuery.call(
        entity_ids: grouped_entities.pluck(:entity_id)
      ).object

      # puts JSON.pretty_generate(query)

      entities = GlobalHelper.elastic_client.search(query)

      # context.object = result['hits']['hits'].map do |entity|
      #   ElasticEntityPresenter.call(entity: entity).object
      # end

      context.object = grouped_entities.map do |group|
        entity = entities['hits']['hits'].find { |item| item['_id'].to_i == group[:entity_id] }
        count = group[:count]

        ElasticEntityPresenter.call(entity:, count:).object
      end
    end
  end
end
