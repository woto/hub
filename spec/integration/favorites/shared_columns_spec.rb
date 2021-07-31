# frozen_string_literal: true

require 'rails_helper'

describe 'Favorites shared columns', type: :system do
  it_behaves_like 'shared columns invisible by default' do
    let(:path) { favorites_path(locale: :ru) }
    let(:object) { create(:favorite, user: user, kind: :offers, created_at: 5.days.ago) }
    let(:column_id) { 'created_at' }
    let(:select_title) { 'Создано' }
    let(:column_title) { 'Создано' }
    let(:column_value) { '5 дней назад' }
  end

  it_behaves_like 'shared columns visible only to admin' do
    let(:path) { favorites_path({ columns: %w[id user_id], order: :desc, per: 20, sort: :id, locale: :ru }) }
    let(:object) { create(:favorite, user: user) }
    let(:column_id) { 'user_id' }
    let(:select_title) { 'User' }
    let(:column_title) { 'User' }
    let(:column_value) { user.id }
  end
end
