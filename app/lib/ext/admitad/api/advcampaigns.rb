# frozen_string_literal: true

module Ext
  module Admitad
    module Api
      class Advcampaigns
        include Interactor

        def call
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
            response = conn.get('advcampaigns/', offset: offset)
            unless response.success?
              context.fail!(
                FailStruct.new(
                  code: response.body['status_code'],
                  message: response.body['error_description']
                ).to_h
              )
            end

            h = response.body
            break if h['results'].empty?

            h['results'].each do |item|
              item['adm_id'] = item.delete('id')
              Ext::Admitad::AdvCampaign.create(item)
            end
            offset += limit
          end
        end
      end
    end
  end
end
