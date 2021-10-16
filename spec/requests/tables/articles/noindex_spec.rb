# frozen_string_literal: true

require 'rails_helper'

describe Tables::ArticlesController, type: :request, responsible: :user do
  let!(:post) { create(:post, tags: ['', 'abc'], published_at: '2020-01-01', user: Current.responsible) }

  describe 'GET /index' do
    let(:params) do
      {}.tap do |h|
        h[:host] = post.realm.domain
        h[:columns] = ['id']
        h[:order] = :desc
        h[:per] = 20
        h[:sort] = :id
        h[:page] = page if page
      end
    end

    context 'when page param is nil' do
      let(:path) { [:articles_url, { params: params }] }
      let(:page) { nil }

      it_behaves_like 'not_to_includes_noindex'
    end

    context 'when page param is 0' do
      let(:path) { [:articles_url, { params: params }] }
      let(:page) { 0 }

      it_behaves_like 'not_to_includes_noindex'
    end

    context 'when page param is 1' do
      let(:path) { [:articles_url, { params: params }] }
      let(:page) { 1 }

      it_behaves_like 'not_to_includes_noindex'
    end

    context 'when page param is 2' do
      let(:path) { [:articles_url, { params: params }] }
      let(:page) { 2 }

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
    let(:params) { { category_id: post.post_category.id, host: post.realm.domain, columns: ['id'], order: :desc, per: 20, sort: :id } }

    it_behaves_like 'includes_robots_noindex'
  end

  describe 'GET /articles/:id' do
    let(:path) { [:article_url, { params: params }] }
    let(:params) { { id: post.id, host: post.realm.domain, columns: ['id'], order: :desc, per: 20, sort: :id } }

    it_behaves_like 'not_to_includes_noindex'
  end
end
