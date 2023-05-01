# frozen_string_literal: true

module Entities
  class IndexInteractor
    include ApplicationInteractor

    contract do
      params do
        required(:params).maybe do
          hash do
            optional(:entity_ids)
            optional(:listing_id)
            optional(:mention_id)
          end
        end
        required(:current_user)
      end
    end

    def call
      entity_ids = context.params[:entity_ids]
      entity_ids = Favorite.find(context.params[:listing_id]).favorites_items.pluck(:ext_id) if context.params[:listing_id]
      entity_ids = Mention.find(context.params[:mention_id]).entities.pluck(:id) if context.params[:mention_id]

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
