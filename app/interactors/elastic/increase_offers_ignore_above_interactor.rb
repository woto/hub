# frozen_string_literal: true

module Elastic
  class IncreaseOffersIgnoreAboveInteractor
    include ApplicationInteractor

    # TODO: move to CreateOffersIndex

    def call
      index = Elastic::IndexName.pick('offers')

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

      context.object = GlobalHelper.elastic_client.indices.put_mapping(index: index.scoped, body: body)
    end
  end
end
