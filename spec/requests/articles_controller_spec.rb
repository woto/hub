# frozen_string_literal: true

require 'rails_helper'

describe ArticlesController, responsible: :admin do
  describe 'GET /articles/:id' do
    let!(:post) { create(:post, status: status, published_at: '2020-01-01', user: Current.responsible) }
    let(:path) { [:article_url, { params: { id: post, host: host } }] }
    let(:host) { post.realm.domain }
    let(:status) { :accrued_post }
    let(:params) { {} }

    it_behaves_like 'not_to_includes_noindex'

    it 'includes correct canonical header' do
      get send(path.first, path.second[:params].merge(params))
      expect(headers.to_h).to include('Link' => %(<http://#{post.realm.domain}/articles/#{post.id}>; rel="canonical"))
    end

    context 'when article belongs to the requested domain' do
      it 'shows article' do
        get send(path.first, path.second[:params].merge(params))
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when article not belongs to the requested domain' do
      let(:host) { create(:realm, kind: :post).domain }

      it 'shows not_found error' do
        get send(path.first, path.second[:params].merge(params))
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'with article status equals to :accrued_post' do
      it 'returns :ok status code' do
        get send(path.first, path.second[:params].merge(params))
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with article status not in :accrued_post' do
      let(:status) { Post.statuses.keys.without('accrued_post').sample }

      it 'returns :not_found status code' do
        get send(path.first, path.second[:params].merge(params))
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
