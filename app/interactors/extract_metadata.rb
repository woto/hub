# frozen_string_literal: true

# TODO: to test
class ExtractMetadata
  include ApplicationInteractor
  include Rails.application.routes.url_helpers

  def call
    conn = Faraday.new do |faraday|
      faraday.response :logger # log requests and responses to $stdout
      faraday.request :json # encode req bodies as JSON
      faraday.request :retry # retry transient failures
      faraday.response :follow_redirects # follow redirects
      faraday.response :json # decode response bodies as JSON
      faraday.response :raise_error # raises an exception if response is a 4xx or 5xx code
    end

    res = conn.get('https://validator-api.semweb.yandex.ru/v1.1/url_parser',
                   {
                     apikey: ENV.fetch('YANDEX_MICRODATA_KEY'),
                     url: context.url,
                     lang: 'ru',
                     pretty: true,
                     id: nil,
                     only_errors: false
                   })

    # TODO: rewrite better
    raise res.body unless res.success?

    context.object = res.body
  end
end
