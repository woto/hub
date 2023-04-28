# frozen_string_literal: true

module Entities
  class IndexInteractor
    include ApplicationInteractor

    contract do
      params do
        optional(:entity_ids)
        optional(:listing_id)
        optional(:mention_id)
      end
    end

    def call
      entity_ids = context.entity_ids
      entity_ids = Favorite.find(context.listing_id).favorites_items.pluck(:ext_id) if context.listing_id
      entity_ids = Mention.find(context.mention_id).entities.pluck(:id) if context.mention_id

      query = IndexQuery.call(
        entity_ids:
      ).object

      # puts JSON.pretty_generate(query)

      result = GlobalHelper.elastic_client.search(query)

      context.object = result['hits']['hits'].map do |entity|
        ElasticEntityPresenter.call(entity:).object
      end
    end
  end
end
