# rubocop:disable Metrics/ParameterLists
module OfferCreator
  def self.call(feed_category:,
                id: SecureRandom.uuid,
                url: Faker::Internet.url,
                description: Faker::Lorem.paragraph,
                name: Faker::Commerce.product_name,
                price: Faker::Commerce.price,
                currency_id: Faker::Currency.code,
                pictures: %w[megan_vale.jpg sasha_rose.jpeg angel_rivas.jpg])
    feed = feed_category.feed
    advertiser = feed.advertiser
    offer = {}.tap do |h|
      h['_id'] = "#{id}-#{feed.id}"
      h['feed_id'] = feed.id
      h['advertiser_id'] = advertiser.id
      h['url'] = [{ '#' => url }]
      h['description'] = [{ '#' => description }]
      h['name'] = [{ '#' => name }]
      h['price'] = [{ '#' => price }]
      h['currencyId'] = [{ '#' => currency_id }]
      h['indexed_at'] = Time.current
      h['feed_category_id'] = feed_category.id
      h['feed_category_ids'] = feed_category.path_ids
      h['picture'] = pictures.map { |pic| { Import::Offers::Hashify::HASH_BANG_KEY => "local:///fixtures/#{pic}" } }

      feed_category.path.each_with_index do |fc, i|
        h["feed_category_id_#{i}"] = fc.id
      end

      h['favorite_ids'] = [].tap do |a|
        a << "advertiser_id:#{feed_category.feed.advertiser.id}"
        a << "feed_id:#{feed_category.feed.id}"
        feed_category.path.each do |fc|
          a << "feed_category_id:#{fc.id}"
        end
      end
    end
    FactoryBot.create(:offer, offer)
  end
end
# rubocop:enable Metrics/ParameterLists
