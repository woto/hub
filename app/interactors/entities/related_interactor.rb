# frozen_string_literal: true

module Entities
  class RelatedInteractor
    include ApplicationInteractor

    contract do
      params do
        optional(:q)
        optional(:entity_ids)
        optional(:entity_title)
      end
    end

    def call
      query = RelatedQuery.call(
        q: context.q,
        entity_ids: context.entity_ids,
        entity_title: context.entity_title,
        from: 0,
        size: 0
      ).object
      result = GlobalHelper.elastic_client.search(query)

      # pp result
      # raise 'exit'

      array_of_ids = result['aggregations']['group']['group']['group']['buckets'].map { |h| h['key'] }
      entities = Entity.includes(:topics, :lookups, images_relations: :image)
                       .find(array_of_ids)
                       .sort_by { |entity| array_of_ids.index(entity.id) }

      context.object = entities.map do |entity|
        EntityPresenter.call(entity: entity).object
      end

    end
  end
end
