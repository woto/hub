# frozen_string_literal: true

require 'rails_helper'

describe ArticlesController, responsible: :admin do
  describe 'GET /articles/:id' do
    let!(:post) { create(:post, status: :accrued_post, published_at: '2020-01-01', user: Current.responsible) }
    let(:path) { article_url(id: post, host: host) }
    let(:host) { post.realm.domain }

    it_behaves_like 'not_to_includes_noindex'

    it 'includes correct canonical header' do
      get path
      expect(headers.to_h).to include('Link' => %(<http://#{post.realm.domain}/articles/#{post.id}>; rel="canonical"))
    end

    context 'when article belongs to the requested domain' do
      it 'shows article' do
        get path
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when article not belongs to the requested domain' do
      let(:host) { create(:realm).domain }

      it 'shows not_found error' do
        get path
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
