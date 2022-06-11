# frozen_string_literal: true

module Extractors
  module YandexRu
    class Xml
      include ApplicationInteractor
      include Rails.application.routes.url_helpers

      def call
        conn = Faraday.new do |faraday|
          # faraday.response :logger # log requests and responses to $stdout
          faraday.response :follow_redirects # follow redirects
          faraday.response :raise_error # raises an exception if response is a 4xx or 5xx code
          faraday.request :json # encode req bodies as JSON
          faraday.response :xml # decode response bodies as XML
        end

        res = begin
          conn.get('https://yandex.ru/search/xml', {
                     user: ENV.fetch('YANDEX_XML_USER'),
                     key: ENV.fetch('YANDEX_XML_KEY'),
                     query: context.q,
                     l10n: 'ru',
                     sortby: 'rlv',
                     filter: 'none',
                     maxpassages: 5,
                     groupby: 'attr="".mode=flat.groups-on-page=10.docs-in-group=1'
                   })
        rescue Faraday::Error => e
          Rails.logger.error(e)
          fail!(message: e.message)
        end

        context.object = res.body
      end
    end
  end
end
