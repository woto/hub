# frozen_string_literal: true

# TODO: to test
class IndexNow
  include ApplicationInteractor
  include Rails.application.routes.url_helpers

  def call
    conn = Faraday.new do |faraday|
      faraday.use FaradayMiddleware::FollowRedirects
      faraday.adapter Faraday.default_adapter
    end

    res = conn.get('https://yandex.com/indexnow',
                   {
                     url: context.url,
                     key: ENV.fetch('INDEX_NOW_KEY'),
                     keyLocation: index_now_url(host: ENV['DOMAIN_NAME'], protocol: 'https')
                   })

    # TODO: rewrite better
    raise res.body unless res.success?
  end
end
