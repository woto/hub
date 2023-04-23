module Import
  module Offers
    class FavoriteIdsInteractor
      FAVORITE_IDS_KEY = 'favorite_ids'

      def self.call(offer, advertiser, feed)
        categories = *offer[Import::Offers::CategoryInteractor::CATEGORY_IDS_KEY].map do |feed_category_id|
          "feed_category_id:#{feed_category_id}"
        end

        offer[FAVORITE_IDS_KEY] = [
          "advertiser_id:#{advertiser.id}",
          "feed_id:#{feed.id}",
          *categories
        ]
      end
    end
  end
end
