# frozen_string_literal: true

module Import
  module Offers
    module Customs
      class Aliexpress
        def self.call(offer, feed)
          return if feed.advertiser.name != 'AliExpress WW'

          # NOTE: seems not actual anymore
          offer['name'] = offer['name'].presence || offer.delete('title')
          offer['picture'] = offer['picture'].presence || offer.delete('image')
        end
      end
    end
  end
end
