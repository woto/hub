# frozen_string_literal: true

module Sync
  module Admitad
    class Sync

      class AttributesMapper
        class << self
          def id(obj, val)
            obj.ext_id = val
          end

          def name(obj, val)
            obj.name = val
          end
        end
      end

      include ApplicationInteractor
      LIMIT = 100

      def call
        conn = Faraday.new(
          url: 'https://api.admitad.com/',
          params: { limit: LIMIT, website: ENV['ADMITAD_WEBSITE'], has_tool: 'products' },
          headers: { 'Authorization' => "Bearer #{context.token}" },
          request: {
            # timeout: ,
            # open_timeout: ,
            read_timeout: 180
          }
        ) do |conn|
          conn.response :json, content_type: 'application/json'
        end

        offset = 0
        loop do
          # https://www.admitad.com/ru/developers/doc/api_ru/methods/advcampaigns/advcampaigns-website-list/
          Rails.logger.info("Processing #{offset} with #{LIMIT} limit")
          response = conn.get("advcampaigns/website/#{ENV['ADMITAD_WEBSITE']}/", offset: offset)

          unless response.success?
            fail!(code: response.body['status_code'],
                  message: response.body['error_description'])
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
          advertiser = Advertiser
                       .lock
                       .where(network: 'admitad', ext_id: adv['id'])
                       .first_or_initialize

          adv.each do |k, v|
            method_name = k
            if AttributesMapper.respond_to?(method_name)
              AttributesMapper.public_send(method_name, advertiser, v)
            end
          end
          advertiser.raw = adv
          attach_picture(advertiser, adv['image'])
          advertiser.synced_at = Time.current
          # TODO: send errors to monitoring if the record cannot be saved
          advertiser.save
          yield(advertiser, adv['feeds_info'])
        end
      end

      def attach_picture(advertiser, picture_url)
        io = URI.parse(picture_url).open
        advertiser.picture.attach(io: io, filename: SecureRandom.uuid)
      end

      def create_or_update_feed(advertiser, feeds_info)
        feeds_info.each do |feed_info|
          feed_id = feed_info['xml_link'].match(/(?<=feed_id=)\d+/)[0]
          feed = Feed
                 .lock
                 .where(advertiser: advertiser, ext_id: feed_id)
                 .first_or_initialize
          feed.update!(feed_attributes(feed_info))
        end
      end

      def feed_attributes(feed_info)
        {
          operation: 'sync',
          name: feed_info['name'],
          url: feed_info['xml_link'],
          raw: feed_info,
          synced_at: Time.current
        }
      end
    end
  end
end
