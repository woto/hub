# frozen_string_literal: true

module Interactors
  module Posts
    class Tags
      include ApplicationInteractor

      def call
        body = {
          size: 0,
          aggregations: {
            grouped_documents: {
              filter: {
                bool: {
                  must: {
                    multi_match: {
                      query: context.q,
                      type: 'bool_prefix',
                      fields: %w[tags.autocomplete tags.autocomplete._2gram tags.autocomplete._3gram]
                    }
                  },
                  filter: [
                    {
                      term: {
                        realm_id: context.realm_id
                      }
                    }
                  ]
                }
              },
              aggregations: {
                grouped_tags: {
                  terms: {
                    field: 'tags.keyword',
                    size: 50
                  }
                }
              }
            }
          }
        }

        tags = Post.__elasticsearch__.search(body)

        context.object = tags.aggregations.grouped_documents.grouped_tags.buckets.map do |tag|
          {
            title: tag['key']
          }
        end
      end
    end
  end
end
