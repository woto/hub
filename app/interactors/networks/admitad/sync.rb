# frozen_string_literal: true

class Networks::Admitad::Sync
  include ApplicationInteractor
  LIMIT = 100

  def call
    conn = Faraday.new(
      url: 'https://api.admitad.com/',
      params: { limit: LIMIT, website: ENV['ADMITAD_WEBSITE'], has_tool: 'products' },
      headers: { 'Authorization' => "Bearer #{context.token}" }
    ) do |conn|
      conn.response :json, content_type: 'application/json'
    end

    offset = 0
    loop do
      # https://www.admitad.com/ru/developers/doc/api_ru/methods/advcampaigns/advcampaigns-website-list/
      Rails.logger.info("Processing #{offset} with #{LIMIT} limit")
      response = conn.get("advcampaigns/website/#{ENV['ADMITAD_WEBSITE']}/", offset: offset)

      unless response.success?
        fail!(code: response.body['status_code'], message: response.body['error_description'])
      end

      h = response.body
      break if h['results'].empty?

      create_or_update_advertiser(h) do |advertiser, feeds_info|
        create_or_update_feed(advertiser, feeds_info)
      end

      offset += LIMIT
    end
  end

  private

  def create_or_update_advertiser(advs)
    advs['results'].each do |adv|
      advertiser = Advertisers::Admitad
                   .lock
                   .where(ext_id: adv['id'])
                   .first_or_initialize

      adv.each do |k, v|
        advertiser.public_send("_#{k}=", v)
      end
      advertiser.data = adv.to_s
      advertiser.synced_at = Time.current
      advertiser.save!
      yield(advertiser, adv['feeds_info'])
    end
  end

  def create_or_update_feed(advertiser, feeds_info)
    feeds_info.each do |feed_info|
      feed = Feed
             .lock
             .where(advertiser: advertiser, ext_id: feed_id(feed_info))
             .first_or_initialize
      feed.update!(feed_attributes(feed_info))
    end
  end

  def feed_attributes(feed_info)
    {
      operation: 'sync',
      name: feed_info['name'],
      url: feed_info['xml_link'],
      advertiser_updated_at: Time.zone.parse(feed_info['advertiser_last_update']),
      network_updated_at: Time.zone.parse(feed_info['admitad_last_update']),
      data: feed_info,
      synced_at: Time.current
    }
  end

  def feed_id(feed_info)
    feed_info['xml_link'].match(/(?<=feed_id=)\d+/)[0]
  end
end
