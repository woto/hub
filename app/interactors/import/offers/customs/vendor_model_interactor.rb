# frozen_string_literal: true

module Import
  module Offers
    module Customs
      class VendorModelInteractor
        def self.call(offer)
          return if offer[Import::Offers::HashifyInteractor::SELF_NAME_KEY]['type'] != 'vendor.model'

          # https://yandex.ru/support/partnermarket-dsbs/elements/vendor-name-model.html
          offer['name'] ||= [
            {
              Import::Offers::HashifyInteractor::HASH_BANG_KEY => [
                offer.dig('typePrefix', 0, Import::Offers::HashifyInteractor::HASH_BANG_KEY),
                offer.dig('vendor', 0, Import::Offers::HashifyInteractor::HASH_BANG_KEY),
                offer.dig('model', 0, Import::Offers::HashifyInteractor::HASH_BANG_KEY)
              ].join(' ')
            }
          ]
        end
      end
    end
  end
end
