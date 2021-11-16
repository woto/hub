# frozen_string_literal: true

require 'rails_helper'

describe API::Posts, type: :request, responsible: :user do
  subject do
    get '/api/posts/tags',
        headers: headers.merge('ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json'),
        params: { q: 'тег', realm_id: realm.id }
  end

  let(:user) { create(:user) }
  let(:realm) { create(:realm, kind: :post, locale: :ru) }
  let(:post_category) { create(:post_category, realm: realm) }

  before do
    create(:post, tags: ['', 'первый тег', 'some tag'], realm: realm, post_category: post_category)
    create(:post, tags: ['', 'тег в этом же realm'], realm: realm, post_category: post_category)
    create(:post, tags: ['', 'mismatch'], realm: realm, post_category: post_category)
    create(:post, tags: ['', 'тег в другом realm'], realm_kind: :post, realm_locale: :en)
  end

  context 'when is not authenticated' do
    let(:headers) { {} }

    it 'requires authentication' do
      subject
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to eq('error' => 'You need to sign in or sign up before continuing.')
    end
  end

  context 'when user is authenticated' do
    let(:headers) { { 'HTTP_API_KEY' => user.api_key } }

    # TODO: The code of Ajax::PostTagsController should be written better.
    # We do not want to see here non matching tags - "some tag".
    # For now it's acceptable because selectize itself filter out bad tags.

    it 'returns tags' do
      subject
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to contain_exactly(
        { 'title' => '' },
        { 'title' => 'some tag' },
        { 'title' => 'первый тег' },
        { 'title' => 'тег в этом же realm' }
      )
    end
  end
end
