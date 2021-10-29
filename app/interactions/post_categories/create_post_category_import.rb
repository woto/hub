# frozen_string_literal: true

module PostCategories
  class CreatePostCategoryImport < ActiveInteraction::Base
    # https://yandex.ru/support/partnermarket-dsbs/guides/classification.html
    # https://support.google.com/merchants/answer/6324436?hl=ru
    AVAILABLE_URLS = {
      GoogleMerchantImportJob => %w[https://www.google.com/basepages/producttype/taxonomy-with-ids.ru-RU.xls
                                    http://www.google.com/basepages/producttype/taxonomy-with-ids.en-US.xls
                                    http://www.google.com/basepages/producttype/taxonomy-with-ids.en-GB.xls
                                    http://www.google.com/basepages/producttype/taxonomy-with-ids.de-DE.xls
                                    http://www.google.com/basepages/producttype/taxonomy-with-ids.fr-FR.xls
                                    https://www.google.com/basepages/producttype/taxonomy-with-ids.uk-UA.xls
                                    https://www.google.com/basepages/producttype/taxonomy-with-ids.es-ES.xls],
      YandexMarketImportJob => ['https://download.cdn.yandex.net/market/market_categories.xls']
    }.freeze

    integer :realm_id, default: nil
    string :url, default: nil

    validates :url, inclusion: { in: AVAILABLE_URLS.values.flatten }
    validates :realm_id, :url, presence: true

    def execute
      realm = Realm.find(realm_id)
      case url
      when *AVAILABLE_URLS[GoogleMerchantImportJob]
        GoogleMerchantImportJob.perform_later(realm, url)
      when *AVAILABLE_URLS[YandexMarketImportJob]
        YandexMarketImportJob.perform_later(realm, url)
      else
        raise 'there is no such import job'
      end
    end
  end
end
