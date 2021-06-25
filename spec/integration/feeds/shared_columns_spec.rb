# frozen_string_literal: true

require 'rails_helper'

describe 'Feeds shared columns', type: :system do
  let(:path) { feeds_path(locale: :ru) }
  let(:user) { create(:user) }

  it_behaves_like 'shared columns invisible by default' do
    let(:object) { create(:feed, updated_at: 1.day.ago) }
    let(:select_title) { 'Дата изменения прайса' }
    let(:column_title) { 'Изменен' }
    let(:column_value) { 'день назад' }
  end
end
