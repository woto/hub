# frozen_string_literal: true

require 'rails_helper'

describe 'EntitiesController#show', type: :system do
  subject!(:entity) { create(:entity, title: 'title', intro: 'intro') }

  before do
    visit entity_path(id: entity)
  end

  it 'has correct title' do
    expect(page).to have_css('h1', text: entity.title)
  end

  it 'includes correct seo meta title tag' do
    expect(page).to have_css('title', text: entity.title, visible: :hidden)
  end

  it 'includes correct seo description meta tag' do
    tag = find('meta[name="description"]', visible: :hidden)
    expect(tag['content']).to eq(entity.intro)
  end
end