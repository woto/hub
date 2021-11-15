# frozen_string_literal: true

require_relative 'validations/url'

module API
  class Tools < ::Grape::API
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
        result = Interactors::Tools::ScrapeWebpage.call(url: params[:url]).object
        status result[:status]
        body result[:body]
      end
    end
  end
end
