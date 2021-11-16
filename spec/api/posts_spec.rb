# frozen_string_literal: true

require 'rails_helper'

describe API::Posts, type: :request, responsible: :user do
  let(:user) { create(:user) }

  describe 'GET /api/posts/leaves_categories' do
    subject do
      get '/api/posts/leaves_categories',
          headers: headers.merge('ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json'),
          params: params
    end

    let(:realm) { Realm.pick(locale: :ru, kind: :post) }
    let!(:parent) { create(:post_category, title: 'Родительская категория', realm: realm) }
    let!(:child) { create(:post_category, title: 'Дочерняя категория', realm: realm, parent: parent) }

    before do
      another_realm = Realm.pick(locale: :en, kind: :post)
      create(:post_category, title: 'Другая категория', realm: another_realm)
    end

    context 'when user is not authorized' do
      let(:params) { { q: 'кат', realm_id: realm.id } }
      let(:headers) { {} }

      it 'requires authentication' do
        subject
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq('error' => 'You need to sign in or sign up before continuing.')
      end
    end

    context 'when user is authenticated' do
      let(:params) { { q: 'кат', realm_id: realm.id } }
      let(:headers) { { 'HTTP_API_KEY' => user.api_key } }

      it 'returns leaf categories' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq(['id' => child.id.to_s,
                                            'path' => 'Родительская категория',
                                            'title' => 'Дочерняя категория'])
      end

      context 'when search query includes only in path and not in leaf category itself' do
        let(:params) { { q: 'род', realm_id: realm.id } }
        let(:headers) { { 'HTTP_API_KEY' => user.api_key } }

        it "finds leaf's category" do
          subject
          expect(response).to have_http_status(:ok)
          expect(response.parsed_body).to eq(['id' => child.id.to_s,
                                              'path' => 'Родительская категория',
                                              'title' => 'Дочерняя категория'])
        end
      end
    end
  end

  describe 'GET /api/posts/tags' do
    subject do
      get '/api/posts/tags',
          headers: headers.merge('ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json'),
          params: { q: 'тег', realm_id: realm.id }
    end

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
end
