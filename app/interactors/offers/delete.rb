# frozen_string_literal: true

class Offers::Delete
  include ApplicationInteractor

  def call
    client = Elasticsearch::Client.new Rails.application.config.elastic
    index_name = Elastic::IndexName.offers(context.feed.index_name)
    begin
      # Add result logging, which includes removed documents' count
      client.delete_by_query(
        index: index_name,
        body: {
          query: {
            bool: {
              must_not: {
                term: {
                  'attempt_uuid.keyword' => context.feed.attempt_uuid
                }
              }
            }
          }
        }
      )
    rescue Elasticsearch::Transport::Transport::Errors::NotFound => e
      Rails.logger.info("There is no such index #{index_name}")
    # Elasticsearch optimistic locking doesn't have time to update indexed document. Retry operation
    # TODO: endless loop breaker?
    # TODO: add column to feeds with removed count
    rescue Elasticsearch::Transport::Transport::Errors::Conflict => e
      sleep 1
      retry
    end
  end
end
