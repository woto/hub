# frozen_string_literal: true

module Offers
  class Delete
    include ApplicationInteractor

    def call
      unless context.feed
        Rails.logger.info('There are no feeds to delete')
        return
      end

      client = Elasticsearch::Client.new Rails.application.config.elastic
      begin
        # Add result logging, which includes removed documents' count
        client.delete_by_query(
          index: Elastic::IndexName.offers,
          routing: context.feed.id,
          body: {
            query: {
              bool: {
                must_not: {
                  term: {
                    'attempt_uuid.keyword' => context.feed.attempt_uuid
                  }
                },
                filter: {
                  term: {
                    'feed_id' => context.feed.id
                  }
                }
              }
            }
          }
        )
      rescue Elasticsearch::Transport::Transport::Errors::NotFound => e
        Rails.logger.info("Couldn't delete #{e.message}")
        sleep 1
      # Elasticsearch optimistic locking doesn't have time to update indexed document. Retry operation
      # TODO: endless loop breaker?
      # TODO: add column to feeds with removed count
      rescue Elasticsearch::Transport::Transport::Errors::Conflict => e
        sleep 1
        retry
      end
    end
  end
end
