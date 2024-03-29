# frozen_string_literal: true

module Import
  class DeleteOldOffersInteractor
    include ApplicationInteractor

    contract do
      params do
        config.validate_keys = true
        required(:feed).maybe(type?: Feed)
      end
    end

    def call
      return unless context.feed

      # TODO: read more thoughtfully. May be it does not needed to refresh offers index before delete_by_query
      # or may be it does not needed to manually refresh index after delete_by_query
      # https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-delete-by-query.html
      Elastic::RefreshOffersIndexInteractor.call
      query = DeleteOldOffersQuery.call(feed: context.feed).object
      result = GlobalHelper.elastic_client.delete_by_query(query)
      # TODO test it later
      Rails.logger.info(message: 'Deleted old offers', deleted: result['deleted'])
      # TODO test it later
      Yabeda.hub.delete_old_offers.set({ feed_id: context.feed.id }, result['deleted'])
    end
  end
end
