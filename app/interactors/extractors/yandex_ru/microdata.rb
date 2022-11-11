# frozen_string_literal: true

module Extractors
  module YandexRu
    class Microdata
      include ApplicationInteractor
      include Rails.application.routes.url_helpers

      def call
        conn = Faraday.new do |faraday|
          # faraday.response :logger # log requests and responses to $stdout
          faraday.request :retry # retry transient failures
          faraday.response :follow_redirects # follow redirects
          faraday.response :raise_error # raises an exception if response is a 4xx or 5xx code
          faraday.response :json # decode response bodies as JSON
          faraday.options.read_timeout = 10
          faraday.options.open_timeout = 10
          faraday.options.timeout = 10
        end

        begin
          if context.url
            res = conn.get(generate_api_url(grab_url: context.url))
          elsif context.html.present?
            res = conn.post(generate_api_url, context.html)
          else
            return
          end

          context.object = res.body if res.body.present?
        rescue Faraday::Error => e
          Rails.logger.error(e)
          fail!(message: e.message)
        end
      end

      private

      def generate_api_url(grab_url: nil)
        query_hash = {
          apikey: ENV.fetch('YANDEX_MICRODATA_KEY'),
          lang: 'ru',
          pretty: true,
          id: nil,
          only_errors: false
        }

        if grab_url
          path_string = 'url_parser'
          query_hash[:url] = grab_url
        else
          path_string = 'document_parser'
        end

        URI::HTTPS.build(host: 'validator-api.semweb.yandex.ru', path: "/v1.1/#{path_string}",
                         query: query_hash.to_query)
      end
    end
  end
end
