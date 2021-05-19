# frozen_string_literal: true

module Import
  module Offers
    module Customs
      class Aliexpress
        def self.call(offer, feed)
          return if feed.advertiser.name != 'AliExpress WW'

          offer['name'] = offer.delete('title')
          offer['picture'] = offer.delete('image')
        end
      end
    end
  end
end
