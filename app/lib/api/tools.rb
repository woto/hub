# frozen_string_literal: true

require_relative 'validations/url'

module API
  class Tools < ::Grape::API
    prefix :api

    resource :tools do

      desc 'Search rubygems.org' do
        security [{ api_key: [] }]
      end

      params do
        requires :q, type: String, desc: 'query string'
      end

      get :rubygems do
        Extractors::RubygemsOrg::Search.call(q: params[:q]).object
      end

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

      desc 'Search for npmjs.org' do
        security [{ api_key: [] }]
      end

      params do
        requires :q, type: String, desc: 'query string'
      end

      get :npmjs do
        Extractors::NpmjsCom::Suggestions.call(q: params[:q]).object
      end

      desc 'Search Google Graph' do
        security [{ api_key: [] }]
      end

      params do
        requires :q, type: String, desc: 'query string'
      end

      get :google_graph do
        Extractors::GoogleCom::Graph.call(q: params[:q]).object
      end

      desc 'Search Yandex XML' do
        security [{ api_key: [] }]
      end

      params do
        requires :q, type: String, desc: 'query string'
      end

      get :yandex_xml do
        Extractors::YandexRu::Xml.call(q: params[:q]).object
      end
    end
  end
end
