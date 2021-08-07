# frozen_string_literal: true

module Elastic
  class IncreaseOffersIgnoreAbove
    include ApplicationInteractor

    # TODO: move to CreateOffersIndex

    def call
      index_name = Elastic::IndexName.offers
      body = {
        "properties": {
          "url": {
            "properties": {
              "#": {
                "type": 'text',
                "fields": {
                  "keyword": {
                    "type": 'keyword',
                    "ignore_above": 2049
                  }
                }
              }
            }
          }
        }
      }

      context.object = GlobalHelper.elastic_client.indices.put_mapping(index: index_name, body: body)
    end
  end
end
