# frozen_string_literal: true

# require_relative 'validations/url'

module API
  class Tools < ::Grape::API
    prefix :api

    resource :tools do
      auth :api_key

      desc 'Search wikipedia.org' do
        security [{ api_key: [] }]
      end

      params do
        requires :q, type: String, desc: 'query string'
        optional :lang, type: String, desc: 'page language'
      end

      get :wikipedia do
        Extractors::WikipediaOrg::SearchInteractor.call(q: params[:q], page_language: params[:lang]).object
      end

      desc 'Search github.com' do
        security [{ api_key: [] }]
      end

      params do
        requires :q, type: String, desc: 'Full url like https://github.com/rails/rails or label like rails/rails'
      end

      get :github do
        Extractors::GithubCom::IndexInteractor.call(q: params[:q]).object
      end

      desc 'Retrieve data from t.me' do
        security [{ api_key: [] }]
      end

      params do
        requires :q, type: String, desc: 'Full url like https://t.me/BotFather or label like BotFather'
      end

      get :telegram do
        Extractors::TMe::ChannelOrChatOrBotInteractor.call(label: params[:q]).object
      end

      desc 'Search rubygems.org' do
        security [{ api_key: [] }]
      end

      params do
        requires :q, type: String, desc: 'query string'
      end

      get :rubygems do
        Extractors::RubygemsOrg::SearchInteractor.call(q: params[:q]).object
      end

      desc 'Search youtube.com' do
        security [{ api_key: [] }]
      end

      params do
        requires :q, type: String, desc: 'query string'
      end

      get :youtube do
        Extractors::YoutubeCom::IndexInteractor.call(q: params[:q]).object
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
        result = Extractors::Metadata::IframelyInteractor.call(url: params[:url])
        break result.object if result.success?

        error!({ error: result.message }, result.code)
      end

      desc 'Take screenshot of passed website' do
        security [{ api_key: [] }]
      end

      params do
        # requires :url, type: String, url: true, desc: 'URL of website'
        requires :url, type: String, desc: 'URL of website'
      end

      get :scrape_webpage do
        result = Extractors::Metadata::ScrapperInteractor.call(url: params[:url])
        break result.object if result.success?

        error!({ error: result.message }, result.code)
      end

      desc 'Search for npmjs.org' do
        security [{ api_key: [] }]
      end

      params do
        requires :q, type: String, desc: 'query string'
      end

      get :npmjs do
        Extractors::NpmjsCom::SuggestionsInteractor.call(q: params[:q]).object
      end

      desc 'Search for Duck Duck Go' do
        security [{ api_key: [] }]
      end

      params do
        requires :q, type: String, desc: 'query string'
      end

      get :duckduckgo_instant do
        Extractors::DuckduckgoCom::InstantAnswerInteractor.call(q: params[:q]).object
      end

      desc 'Search Google Graph' do
        security [{ api_key: [] }]
      end

      params do
        requires :q, type: String, desc: 'query string'
      end

      get :google_graph do
        Extractors::GoogleCom::GraphInteractor.call(q: params[:q]).object
      end

      desc 'Search Google Custom Search' do
        security [{ api_key: [] }]
      end

      params do
        requires :q, type: String, desc: 'query string'
      end

      get :google_custom_search do
        Extractors::GoogleCom::CustomSearchInteractor.call(q: params[:q]).object
      end

      desc 'Extract metadata from the page using yandex.com' do
        consumes ['multipart/form-data']
        security [{ api_key: [] }]
      end

      params do
        optional :html, type: String, desc: 'Html content of the page'
        optional :url, type: String, desc: 'Page URL'
        exactly_one_of :html, :url
      end

      post :yandex_microdata do
        Extractors::YandexRu::MicrodataInteractor.call(url: params[:url], html: params[:html]).object
      end

      format :txt

      desc 'Search Yandex XML' do
        security [{ api_key: [] }]
        produces ['application/xml']
      end

      params do
        requires :q, type: String, desc: 'query string'
      end

      get :yandex_xml do
        header 'Content-Type', 'application/xml'
        Extractors::YandexRu::XmlInteractor.call(q: params[:q]).object
      end

      desc 'Add "tw" prefix to Tailwind classess. https://tailwindcss.com/docs/configuration#prefix' do
        consumes ['multipart/form-data']
      end

      params do
        requires :html, type: String, desc: 'html fragment e.g. <div class="-t-1 hover:t-1 bg-red"></div>'
      end

      post :prefix_tailwind do
        ::Tools::PrefixTailwindInteractor.call(html: params[:html]).object
      end
    end
  end
end
