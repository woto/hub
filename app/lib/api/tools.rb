# frozen_string_literal: true

require_relative 'validations/url'

module API
  class Tools < ::Grape::API
    version 'v1', using: :header, vendor: 'hub'
    format :json
    prefix :api

    resource :tools do
      desc 'Detect a language of passed string'

      params do
        requires :text, type: String, desc: 'Detected string'
      end

      get :detect_language do
        CLD.detect_language(params[:text]).stringify_keys
      end

      desc 'Take screenshot of passed website'

      params do
        requires :url, type: String, url: true, desc: 'URL of website'
      end

      get :scrape_webpage do
        url = URI::HTTP.build([nil, ENV.fetch('SCRAPPER_HOST'), ENV.fetch('SCRAPPER_PORT'),
                               '/screenshot', "url=#{params[:url]}", nil])

        connection = Faraday.new(url: url) do |faraday|
          faraday.use FaradayMiddleware::FollowRedirects
          faraday.adapter Faraday.default_adapter
          faraday.response :json

          faraday.options.open_timeout = 2
          faraday.options.timeout = 5
        end

        result = connection.get(url)
        result.body
      end
    end
  end
end
