# frozen_string_literal: true

module Entities
  class SeekInteractor
    include ApplicationInteractor

    def call
      # sleep 0.5
      fragment = Fragment::Parser.call(fragment_url: context.fragment_url)
      pagination_rule = PaginationRules.new(page: context.page, per: context.per)

      query = ThingsSearchQuery.call(
        fragment:,
        search_string: context.search_string,
        link_url: context.link_url,
        from: pagination_rule.from,
        size: pagination_rule.per
      ).object

      Rails.logger.info(query.to_json)

      @entities = GlobalHelper.elastic_client.search(query)

      context.object = @entities['hits']['hits'].map do |entity|
        ElasticEntityPresenter.call(entity: entity).object
      end
    end
  end
end
