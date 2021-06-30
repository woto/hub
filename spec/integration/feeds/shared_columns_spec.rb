# frozen_string_literal: true

require 'rails_helper'

describe 'Feeds shared columns', type: :system, focus: true do
  it_behaves_like 'shared columns invisible by default' do
    let(:path) { feeds_path(locale: :en) }
    let(:object) { create(:feed, updated_at: 1.day.ago) }
    let(:column_id) { 'updated_at' }
    let(:select_title) { 'Updated At' }
    let(:column_title) { 'Updated At' }
    let(:column_value) { 'a day ago' }
  end

  it_behaves_like 'shared columns visible only to admin' do
    let(:path) { feeds_path({ cols: '0.18', order: :desc, per: 20, sort: :id, locale: :ru }) }
    let(:object) { create(:feed, xml_file_path: 'fake') }
    let(:column_id) { 'xml_file_path' }
    let(:select_title) { 'Путь до прайса' }
    let(:column_title) { 'Путь прайса' }
    let(:column_value) { 'fake' }
  end
end
