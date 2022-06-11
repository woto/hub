# frozen_string_literal: true

require 'rails_helper'

describe API::Tools, type: :request do
  let!(:user) { create(:user) }

  describe 'GET /api/tools/yandex' do
    context 'with url parameter' do
      it 'returns yandex extracted metadata' do
        stub_request(:get, 'https://validator-api.semweb.yandex.ru/v1.1/url_parser?apikey=yandex_microdata_key_value&id=&lang=ru&only_errors=false&pretty=true&url=https://example.com')
          .to_return(status: 200, body: { 'a' => 'b' }.to_json, headers: {})

        post '/api/tools/yandex', headers: { 'HTTP_API_KEY' => user.api_key }, params: { url: 'https://example.com' }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to eq({ 'a' => 'b' })
      end
    end

    context 'with html parameter' do
      it 'returns yandex extracted metadata' do
        stub_request(:post, 'https://validator-api.semweb.yandex.ru/v1.1/document_parser?apikey=yandex_microdata_key_value&id=&lang=ru&only_errors=false&pretty=true')
          .to_return(status: 200, body: { 'a' => 'b' }.to_json, headers: {})

        post '/api/tools/yandex', headers: { 'HTTP_API_KEY' => user.api_key }, params: { html: '<html></html>' }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to eq({ 'a' => 'b' })
      end
    end

    context 'when user is not authorized' do
      it 'returns error' do
        get '/api/tools/yandex',
            headers: { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq('error' => 'You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when API key is incorrect' do
      it 'returns error' do
        get '/api/tools/yandex',
            headers: { 'API-KEY' => '123', 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq(
          'error' => 'Invalid API key. Use API-KEY header or api_key query string parameter.'
        )
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when text is empty' do
      it 'returns error' do
        get '/api/tools/detect_language', headers: { 'HTTP_API_KEY' => user.api_key }
        # TODO: should be 422
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq('error' => 'text is missing')
      end
    end
  end

  describe 'GET /api/tools/iframely' do
    it 'returns iframely extracted metadata' do
      stub_request(:get, 'http://localhost:8061/iframely?url=https://example.com')
        .to_return(status: 200, body: { a: 'b' }.to_json, headers: {})

      get '/api/tools/iframely', headers: { 'HTTP_API_KEY' => user.api_key }, params: { url: 'https://example.com' }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({ 'a' => 'b' })
    end

    context 'when user is not authorized' do
      it 'returns error' do
        get '/api/tools/iframely',
            headers: { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq('error' => 'You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when API key is incorrect' do
      it 'returns error' do
        get '/api/tools/iframely',
            headers: { 'API-KEY' => '123', 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq(
          'error' => 'Invalid API key. Use API-KEY header or api_key query string parameter.'
        )
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when text is empty' do
      it 'returns error' do
        get '/api/tools/detect_language', headers: { 'HTTP_API_KEY' => user.api_key }
        # TODO: should be 422
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq('error' => 'text is missing')
      end
    end
  end

  describe 'GET /api/tools/detect_language' do
    it 'returns detected language' do
      get '/api/tools/detect_language', headers: { 'HTTP_API_KEY' => user.api_key }, params: { text: 'test' }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({ 'code' => 'en', 'name' => 'ENGLISH', 'reliable' => true })
    end

    context 'when user is not authorized' do
      it 'returns error' do
        get '/api/tools/detect_language',
            headers: { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq('error' => 'You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when API key is incorrect' do
      it 'returns error' do
        get '/api/tools/detect_language',
            headers: { 'API-KEY' => '123', 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq(
          'error' => 'Invalid API key. Use API-KEY header or api_key query string parameter.'
        )
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when text is empty' do
      it 'returns error' do
        get '/api/tools/detect_language', headers: { 'HTTP_API_KEY' => user.api_key }
        # TODO: should be 422
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq('error' => 'text is missing')
      end
    end
  end

  describe 'GET /api/tools/scrape_webpage' do
    # TODO: create separate test file with separate services' tests
    it 'returns scrapped data' do
      stub_request(:get, 'http://scrapper:4000/screenshot?url=https://ya.ru')
        .to_return(status: 200, body: { key: 'value' }.to_json, headers: {})

      get '/api/tools/scrape_webpage', headers: { 'HTTP_API_KEY' => user.api_key }, params: { url: 'https://ya.ru' }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq('key' => 'value')
    end

    context 'when user is not authorized' do
      it 'returns error' do
        get '/api/tools/scrape_webpage',
            headers: { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq('error' => 'You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when API key is incorrect' do
      it 'returns error' do
        get '/api/tools/scrape_webpage',
            headers: { 'API-KEY' => '123', 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq(
          'error' => 'Invalid API key. Use API-KEY header or api_key query string parameter.'
        )
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when url is invalid' do
      it 'returns scrapped data' do
        get '/api/tools/scrape_webpage', headers: { 'HTTP_API_KEY' => user.api_key }, params: { url: 'foo' }

        # TODO: change response code to 422
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'url must be url, e.g. https://ya.ru' })
      end
    end

    context 'when faraday timed out' do
      it 'returns json response' do
        faraday = Faraday.new
        expect(faraday).to receive(:get).and_raise(Faraday::TimeoutError)
        expect_any_instance_of(Extractors::Metadata::Scrapper).to receive(:connection).and_return(faraday)

        get '/api/tools/scrape_webpage', headers: { 'HTTP_API_KEY' => user.api_key }, params: { url: 'http://ya.ru' }
        expect(JSON.parse(response.body)).to eq({ 'error' => 'timeout' })
        # TODO: should be not 5XX status code
        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end

  describe 'GET /api/tools/npmjs' do
    it 'returns npmjs packages list' do
      stub_request(:get, 'https://www.npmjs.com/search/suggestions?q=npmjs&size=20')
        .to_return(status: 200, body: { npmjs: 'npmjs' }.to_json, headers: {})

      get '/api/tools/npmjs', headers: { 'HTTP_API_KEY' => user.api_key }, params: { q: 'npmjs' }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({ 'npmjs' => 'npmjs' })
    end

    context 'when user is not authorized' do
      it 'returns error' do
        get '/api/tools/npmjs',
            headers: { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq('error' => 'You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when API key is incorrect' do
      it 'returns error' do
        get '/api/tools/npmjs',
            headers: { 'API-KEY' => '123', 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq(
          'error' => 'Invalid API key. Use API-KEY header or api_key query string parameter.'
        )
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/tools/rubygems' do
    it 'returns rubygems gems list' do
      stub_request(:get, 'https://rubygems.org/api/v1/search.json?query=rails')
        .to_return(status: 200, body: { rails: 'rails' }.to_json, headers: {})

      get '/api/tools/rubygems', headers: { 'HTTP_API_KEY' => user.api_key }, params: { q: 'rails' }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({ 'rails' => 'rails' })
    end

    context 'when user is not authorized' do
      it 'returns error' do
        get '/api/tools/rubygems',
            headers: { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq('error' => 'You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when API key is incorrect' do
      it 'returns error' do
        get '/api/tools/rubygems',
            headers: { 'API-KEY' => '123', 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq(
          'error' => 'Invalid API key. Use API-KEY header or api_key query string parameter.'
        )
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/tools/google_graph' do
    it 'returns data from Google Graph' do
      stub_request(:get, 'https://kgsearch.googleapis.com/v1/entities:search?query=google-graph&key=google_graph_key_value&limit=10&indent=true&languages=ru')
        .to_return(status: 200, body: { 'google-graph' => 'google-graph' }.to_json, headers: {})

      get '/api/tools/google_graph', headers: { 'HTTP_API_KEY' => user.api_key }, params: { q: 'google-graph' }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({ 'google-graph' => 'google-graph' })
    end

    context 'when user is not authorized' do
      it 'returns error' do
        get '/api/tools/google_graph',
            headers: { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq('error' => 'You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when API key is incorrect' do
      it 'returns error' do
        get '/api/tools/google_graph',
            headers: { 'API-KEY' => '123', 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq(
          'error' => 'Invalid API key. Use API-KEY header or api_key query string parameter.'
        )
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/tools/yandex_xml' do
    it 'returns data from Yandex XML' do
      stub_request(:get, 'https://yandex.ru/search/xml?filter=none&groupby=attr=%22%22.mode=flat.groups-on-page=10.docs-in-group=1&key=yandex_xml_key_value&l10n=ru&maxpassages=5&query=yandex-xml&sortby=rlv&user=yandex_xml_user_value')
        .to_return(status: 200, body: '<yandex_xml>yandex_xml</yandex_xml>', headers: {})

      get '/api/tools/yandex_xml', headers: { 'HTTP_API_KEY' => user.api_key }, params: { q: 'yandex-xml' }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({ 'yandex_xml' => 'yandex_xml' })
    end

    context 'when user is not authorized' do
      it 'returns error' do
        get '/api/tools/yandex_xml',
            headers: { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq('error' => 'You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when API key is incorrect' do
      it 'returns error' do
        get '/api/tools/yandex_xml',
            headers: { 'API-KEY' => '123', 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq(
          'error' => 'Invalid API key. Use API-KEY header or api_key query string parameter.'
        )
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/tools/telegram' do
    shared_examples_for 'successful response from t.me' do
      let(:body) do
        <<~HERE
          <div class="tgme_page">
            <div class="tgme_page_photo">
              <a href="tg://resolve?domain=roastme_bot">
                <img class="tgme_page_photo_image" src="https://example.com/image.png">
              </a>
            </div>
            <div class="tgme_page_title">
              <span dir="auto">roastme.ru</span>
            </div>
            <div class="tgme_page_extra">
              @roastme_bot
            </div>
            <div class="tgme_page_description ">Занимаюсь получением и каталогизированием упоминаний.</div>
          </div>
        HERE
      end

      it 'returns successful response from t.me' do
        stub_request(:get, 'https://t.me/telegram')
          .to_return(status: 200, body: body, headers: {})

        get '/api/tools/telegram', headers: { 'HTTP_API_KEY' => user.api_key }, params: { q: q }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(
          'description' => 'Занимаюсь получением и каталогизированием упоминаний.',
          'image' => 'https://example.com/image.png',
          'kind' => 'telegram_bot',
          'label' => 'telegram',
          'title' => 'roastme.ru'
        )
      end
    end

    context 'when requests url' do
      let(:q) { 'https://t.me/telegram' }

      it_behaves_like 'successful response from t.me'
    end

    context 'when requests label' do
      let(:q) { 'telegram' }

      it_behaves_like 'successful response from t.me'
    end

    context 'when user is not authorized' do
      it 'returns error' do
        get '/api/tools/telegram',
            headers: { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq('error' => 'You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when API key is incorrect' do
      it 'returns error' do
        get '/api/tools/telegram',
            headers: { 'API-KEY' => '123', 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        expect(JSON.parse(response.body)).to eq(
          'error' => 'Invalid API key. Use API-KEY header or api_key query string parameter.'
        )
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
