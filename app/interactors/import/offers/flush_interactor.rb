# frozen_string_literal: true

module Import
  module Offers
    class FlushInteractor
      def self.call(offers, advertiser, feed)
        return if offers.empty?

        res = GlobalHelper.elastic_client.bulk(
          index: Elastic::IndexName.pick('offers').scoped,
          routing: feed.id,
          body: offers.map do |offer|
            {
              index: {
                _id: "#{offer[Import::Offers::HashifyInteractor::SELF_NAME_KEY]['id']}-#{feed.id}",
                data: offer.merge(
                  feed_id: feed.id,
                  advertiser_id: advertiser.id
                )
              }
            }
          end
        )

        raise Import::ProcessInteractor::ElasticResponseError, res['errors'] if res['errors']
      end
    end
  end
end
