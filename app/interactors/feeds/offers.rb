# frozen_string_literal: true

module Feeds
  class Offers
    include ApplicationInteractor
    attr_accessor :total_count, :batch_count

    def initialize(context)
      @offers = []
      @batch_count = 0
      @total_count = 0
      @categories = context.feed.feed_categories_for_import
      super
    end

    def append(doc)
      offer = Import::Offers::Hashify.call(doc)
      Import::Offers::Category.call(offer, context.feed, @categories)
      Import::Offers::StandardAttributes.call(offer, context.feed)
      Import::Offers::DetectLanguage.call(offer)
      Import::Offers::FavoriteIds.call(offer, context.feed.advertiser, context.feed)
      @batch_count += 1
      @total_count += 1
      @offers << offer
    end

    def flush
      Import::Offers::Flush.call(@offers, context.feed.advertiser, context.feed, client)
      @batch_count = 0
      @offers = []
    end
  end
end
