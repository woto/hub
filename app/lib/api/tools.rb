# frozen_string_literal: true

require_relative 'validations/url'

module API
  class Tools < ::Grape::API
    prefix :api

    resource :tools do

      desc 'Extract metadata from the page using yandex.com' do
        consumes ['multipart/form-data']
        security [{ api_key: [] }]
      end

      params do
        optional :html, type: String, desc: 'Html content of the page' #, documentation: { in: 'body' }
        optional :url, type: String, desc: 'Page URL' #, documentation: { in: 'body' }
        exactly_one_of :html, :url
      end

      post :yandex do
        Extractors::Metadata::Yandex.call(url: params[:url], html: params[:html]).object
      end

      desc 'Detect a language of passed string' do
        security [{ api_key: [] }]
      end

      params do
        requires :text, type: String, desc: 'Detected string'
      end

      get :detect_language do
        CLD.detect_language(params[:text]).stringify_keys
      end

      desc 'Extract metadata from the page using iframely.com' do
        security [{ api_key: [] }]
      end

      params do
        requires :url, type: String, desc: 'Page URL'
      end

      get :iframely do
        Extractors::Metadata::Iframely.call(url: params[:url]).object
      end

      desc 'Take screenshot of passed website'

      params do
        requires :url, type: String, url: true, desc: 'URL of website'
      end

      get :scrape_webpage do
        Extractors::Metadata::Scrapper.call(url: params[:url]).object
      end
    end
  end
end
