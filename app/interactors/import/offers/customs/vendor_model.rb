# frozen_string_literal: true

module Import
  module Offers
    module Customs
      class VendorModel
        def self.call(offer)
          return if offer[Import::Offers::Hashify::SELF_NAME_KEY]['type'] != 'vendor.model'

          # https://yandex.ru/support/partnermarket-dsbs/elements/vendor-name-model.html
          offer['name'] ||= [
            {
              Import::Offers::Hashify::HASH_BANG_KEY => [
                offer.dig('typePrefix', 0, Import::Offers::Hashify::HASH_BANG_KEY),
                offer.dig('vendor', 0, Import::Offers::Hashify::HASH_BANG_KEY),
                offer.dig('model', 0, Import::Offers::Hashify::HASH_BANG_KEY)
              ].join(' ')
            }
          ]
        end
      end
    end
  end
end
