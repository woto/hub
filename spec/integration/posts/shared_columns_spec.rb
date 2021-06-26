# frozen_string_literal: true

require 'rails_helper'

describe 'Posts shared columns', type: :system do
  it_behaves_like 'shared columns invisible by default' do
    let(:path) { posts_path(locale: :ru) }
    let(:object) { create(:post, user: user) }
    let(:column_id) { 'intro' }
    let(:select_title) { 'Intro' }
    let(:column_title) { 'Intro' }
    let(:column_value) { 'Просмотр' }
  end

  it_behaves_like 'shared columns visible only to admin' do
    let(:path) { posts_path({ cols: '0.5', order: :desc, per: 20, sort: :id, locale: :ru }) }
    let(:object) { create(:post, user: user, post_category: create(:post_category, realm: create(:realm, domain: 'fake.ru'))) }
    let(:column_id) { 'realm_domain' }
    let(:select_title) { 'Realm Domain' }
    let(:column_title) { 'Realm Domain' }
    let(:column_value) { 'fake.ru' }
  end
end
