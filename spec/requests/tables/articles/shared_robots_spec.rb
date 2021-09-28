# frozen_string_literal: true

require 'rails_helper'

describe Tables::ArticlesController, type: :request, responsible: :user do
  let!(:post) { create(:post, tags: ['', 'abc'], published_at: '2020-01-01', user: Current.responsible) }

  describe 'GET /index' do
    let(:path) { articles_url(host: post.realm.domain, columns: ['id'], order: :desc, per: 20, sort: :id) }
    it_behaves_like 'includes_robots_noindex'
  end

  describe 'GET /month/:month' do
    let(:path) { articles_by_month_url(month: '2020-01', host: post.realm.domain, columns: ['id'], order: :desc, per: 20, sort: :id) }
    it_behaves_like 'includes_robots_noindex'
  end

  describe 'GET /tag/:tag' do
    let(:path) { articles_by_tag_url(tag: 'abc', host: post.realm.domain, columns: ['id'], order: :desc, per: 20, sort: :id) }
    it_behaves_like 'includes_robots_noindex'
  end

  describe 'GET /category/:id' do
    let(:path) { articles_by_category_url(category_id: post.post_category.id, host: post.realm.domain, columns: ['id'], order: :desc, per: 20, sort: :id) }
    it_behaves_like 'includes_robots_noindex'
  end

  describe 'GET /articles/:id' do
    let(:path) { article_url(id: post.id, host: post.realm.domain, columns: ['id'], order: :desc, per: 20, sort: :id) }
    it_behaves_like 'not_to_includes_noindex'
  end
end
