# frozen_string_literal: true

require 'rails_helper'

describe 'Favorites shared columns', type: :system do
  let(:path) { favorites_path(locale: :ru) }
  let(:user) { create(:user) }

  it_behaves_like 'shared columns invisible by default' do
    let(:object) { create(:favorite, user: user, kind: :offers, created_at: 5.days.ago) }
    let(:select_title) { 'Создано' }
    let(:column_title) { 'Создано' }
    let(:column_value) { '5 дней назад' }
  end
end
