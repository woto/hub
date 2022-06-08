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

end
