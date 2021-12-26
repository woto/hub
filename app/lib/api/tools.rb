# frozen_string_literal: true

require_relative 'validations/url'

module API
  class Tools < ::Grape::API
    prefix :api

    resource :tools do

      desc 'Extract metadata from page'

      params do
        requires :url, type: String, desc: 'Page URL'
      end

      # TODO: to test
      get :metadata do
        ExtractMetadata.call(url: params[:url]).object
      end

      desc 'Detect a language of passed string'

      params do
        requires :text, type: String, desc: 'Detected string'
      end

      get :detect_language do
        CLD.detect_language(params[:text]).stringify_keys
      end

      desc 'Extract metadata from the page using iframely.com'

      params do
        requires :url, type: String, desc: 'Page URL'
      end

      get :iframely do
        Extractors::Iframely.call(url: params[:url]).object
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
