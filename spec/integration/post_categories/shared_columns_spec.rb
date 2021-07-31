# frozen_string_literal: true

require 'rails_helper'

describe 'PostCategories shared columns', type: :system do
  it_behaves_like 'shared columns invisible by default' do
    let(:user) { create(:user, role: :admin) }
    let(:path) { post_categories_path(locale: :ru) }
    let(:object) { create(:post_category, realm: create(:realm, kind: :post, locale: :ru)) }
    let(:column_id) { 'realm_locale' }
    let(:select_title) { 'Realm Locale' }
    let(:column_title) { 'Realm Locale' }
    let(:column_value) { 'ru' }
  end

  it_behaves_like 'shared columns visible only to admin' do
    let(:path) { post_categories_path({ columns: %w[id posts_count], order: :desc, per: 20, sort: :id, locale: :ru }) }
    let(:object) { create(:post_category) }
    let(:column_id) { 'posts_count' }
    let(:select_title) { 'Posts Count' }
    let(:column_title) { 'Posts Count' }
    let(:column_value) { '0' }
  end
end
