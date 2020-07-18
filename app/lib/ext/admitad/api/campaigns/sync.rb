# frozen_string_literal: true

module Ext
  module Admitad
    module Api
      module Campaigns
        class Sync
          include ApplicationInteractor

          def call
            Rails.logger.info('Ext::Admitad::Api::Campaigns:Sync')

            limit = 100
            conn = Faraday.new(
              url: 'https://api.admitad.com/',
              params: { limit: limit, website: ENV['ADMITAD_WEBSITE'], has_tool: 'products' },
              headers: { 'Authorization' => "Bearer #{context.token}" }
            ) do |conn|
              conn.response :json, content_type: 'application/json'
            end

            offset = 0
            loop do
              # https://www.admitad.com/ru/developers/doc/api_ru/methods/advcampaigns/advcampaigns-website-list/
              Rails.logger.info("Processing #{offset} with #{limit} limit")
              response = conn.get("advcampaigns/website/#{ENV['ADMITAD_WEBSITE']}/", offset: offset)

              unless response.success?
                fail!(code: response.body['status_code'], message: response.body['error_description'])
              end

              h = response.body
              break if h['results'].empty?

              create_or_update_advertiser(h) do |advertiser, feeds_info|
                create_or_update_feed(advertiser, feeds_info)
              end

              offset += limit
            end

            # Rails.logger.info('Ext::Admitad::Api::Campaigns:Sync')
            # Ext::Admitad::Campaign.delete_all
            #
            # limit = 100
            # conn = Faraday.new(
            #   url: 'https://api.admitad.com/',
            #   params: { limit: limit, website: ENV['ADMITAD_WEBSITE'], has_tool: 'products' },
            #   headers: { 'Authorization' => "Bearer #{context.token}" }
            # ) do |conn|
            #   conn.response :json, content_type: 'application/json'
            # end
            # offset = 0
            # loop do
            #   # https://www.admitad.com/ru/developers/doc/api_ru/methods/advcampaigns/advcampaigns-website-list/
            #   Rails.logger.info("Processing #{offset} with #{limit} limit")
            #   response = conn.get("advcampaigns/website/#{ENV['ADMITAD_WEBSITE']}/", offset: offset)
            #
            #   unless response.success?
            #     fail!(code: response.body['status_code'], message: response.body['error_description'])
            #   end
            #
            #   h = response.body
            #   break if h['results'].empty?
            #
            #   Ext::Admitad::Campaign.collection.insert_many(h['results'])
            #   offset += limit
            # end
          end

          private

          def create_or_update_advertiser(advs)
            advs['results'].each do |adv|
              advertiser = Advertiser
                           .lock
                           .where(ext_id: adv['id'], network: :admitad)
                           .first_or_initialize
              advertiser.update!(advertiser_attributes(adv))
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

          def advertiser_attributes(advertiser)
            {
              name: advertiser['name'],
              ext_id: advertiser['id'],
              data: advertiser,
              last_synced_at: Time.current
            }
          end

          def feed_attributes(feed_info)
            {
              name: feed_info['name'],
              url: feed_info['xml_link'],
              advertiser_updated_at: Time.zone.parse(feed_info['advertiser_last_update']),
              network_updated_at: Time.zone.parse(feed_info['admitad_last_update']),
              data: feed_info,
              last_synced_at: Time.current
            }
          end

          def feed_id(feed_info)
            feed_info['xml_link'].match(/(?<=feed_id=)\d+/)[0]
          end
        end
      end
    end
  end
end
