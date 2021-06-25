# frozen_string_literal: true

require 'rails_helper'

describe 'PostCategories shared columns', type: :system do
  let(:path) { post_categories_path(locale: :ru) }
  let(:user) { create(:user, role: :admin) }

  it_behaves_like 'shared columns invisible by default' do
    let(:object) { create(:post_category, realm: create(:realm, kind: :post, locale: :ru)) }
    let(:select_title) { 'Realm Locale' }
    let(:column_title) { 'Realm Locale' }
    let(:column_value) { 'ru' }
  end
end
