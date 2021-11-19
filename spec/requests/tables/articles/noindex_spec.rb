# frozen_string_literal: true

require 'rails_helper'

describe Tables::ArticlesController, type: :request, responsible: :user do
  let!(:post) { create(:post, tags: ['', 'abc'], published_at: '2020-01-01', user: Current.responsible) }

  describe 'GET /index' do
    let(:path) { [:articles_url, { params: { host: post.realm.domain }.merge(params) }] }

    context 'when page param is nil' do
      let(:params) { { page: nil } }

      it_behaves_like 'not_to_includes_noindex'
    end

    context 'when page param is 0' do
      let(:params) { { page: 0 } }

      it_behaves_like 'not_to_includes_noindex'
    end

    context 'when page param is 1' do
      let(:params) { { page: 1 } }

      it_behaves_like 'not_to_includes_noindex'
    end

    context 'when page param is 2' do
      let(:params) { { page: 2 } }

      it_behaves_like 'includes_robots_noindex'
    end

    context 'when params include :q' do
      let(:params) { { q: 'q' } }

      it_behaves_like 'includes_robots_noindex'
    end

    context 'when params include :per' do
      let(:params) { { per: '10' } }

      it_behaves_like 'includes_robots_noindex'
    end

    context 'when params include :sort' do
      let(:params) { { sort: 'id' } }

      it_behaves_like 'includes_robots_noindex'
    end

    context 'when params include :order' do
      let(:params) { { order: 'desc' } }

      it_behaves_like 'includes_robots_noindex'
    end

    context 'when params include :favorite_id' do
      let(:params) { { favorite_id: '1' } }

      it_behaves_like 'includes_robots_noindex'
    end

    context 'when params include :filters' do
      let(:params) { { filters: { title: { value: 'value' } } } }

      it_behaves_like 'includes_robots_noindex'
    end

    context 'when params include :columns' do
      let(:params) { { columns: ['id'] } }

      it_behaves_like 'includes_robots_noindex'
    end
  end

  describe 'GET /month/:month' do
    let(:path) { [:articles_by_month_url, { params: params }] }
    let(:params) { { month: '2020-01', host: post.realm.domain, columns: ['id'], order: :desc, per: 20, sort: :id } }

    it_behaves_like 'includes_robots_noindex'
  end

  describe 'GET /tag/:tag' do
    let(:path) { [:articles_by_tag_url, { params: params }] }
    let(:params) { { tag: 'abc', host: post.realm.domain, columns: ['id'], order: :desc, per: 20, sort: :id } }

    it_behaves_like 'includes_robots_noindex'
  end

  describe 'GET /category/:id' do
    let(:path) { [:articles_by_category_url, { params: params }] }
    let(:params) do
      { category_id: post.post_category.id, host: post.realm.domain, columns: ['id'], order: :desc, per: 20, sort: :id }
    end

    it_behaves_like 'includes_robots_noindex'
  end

  describe 'GET /articles/:id' do
    let(:path) { [:article_url, { params: params }] }
    let(:params) { { id: post.id, host: post.realm.domain, columns: ['id'], order: :desc, per: 20, sort: :id } }

    it_behaves_like 'not_to_includes_noindex'
  end
end
