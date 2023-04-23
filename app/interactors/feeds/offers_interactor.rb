# frozen_string_literal: true

module Feeds
  class OffersInteractor
    include ApplicationInteractor
    attr_accessor :total_count, :batch_count

    def initialize(hash)
      super
      @offers = []
      @batch_count = 0
      @total_count = 0
      @categories = FeedCategoriesCache.new(context.feed)
    end

    def append(doc)
      offer = Import::Offers::HashifyInteractor.call(doc)
      Import::Offers::Customs::AliexpressInteractor.call(offer, context.feed)
      Import::Offers::Customs::VendorModelInteractor.call(offer)
      Import::Offers::CategoryInteractor.call(offer, context.feed, @categories)
      Import::Offers::StandardAttributesInteractor.call(offer, context.feed)
      Import::Offers::DetectLanguageInteractor.call(offer)
      Import::Offers::FavoriteIdsInteractor.call(offer, context.feed.advertiser, context.feed)
      @batch_count += 1
      @total_count += 1
      @offers << offer
    end

    def flush
      Import::Offers::FlushInteractor.call(@offers, context.feed.advertiser, context.feed)
      @batch_count = 0
      @offers = []
    end
  end
end
