# frozen_string_literal: true

shared_examples 'protected endpoint' do
  context 'when user is not authorized' do
    it 'returns error' do
      process http_method, url,
              headers: { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
      expect(JSON.parse(response.body)).to eq('error' => 'You need to sign in or sign up before continuing.')
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'when API key is incorrect' do
    it 'returns error' do
      process http_method, url,
              headers: { 'API-KEY' => '123', 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
      expect(JSON.parse(response.body)).to eq(
        'error' => 'Invalid API key. Use API-KEY header or api_key query string parameter.'
      )
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
