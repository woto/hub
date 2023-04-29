# frozen_string_literal: true

require 'rails_helper'

describe 'EntitiesController#show', type: :system do
  subject!(:entity) { create(:entity, :with_image, title: 'title', intro: 'intro') }

  let!(:mention) { create(:mention, :with_image, entities: [entity]) }

  before do
    mention.__elasticsearch__.index_document
    Mention.__elasticsearch__.refresh_index!
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

  it "shows mention's thumbnail" do
    expect(page).to have_css("[data-test-id='small-image-#{mention.image.id}']")
  end

  context "when clicks on the mention's thumbnail" do
    before do
      find("[data-test-id='small-image-#{mention.image.id}']").click
    end

    it "shows larger mention's screenshot" do
      expect(page).to have_css("[data-test-id='big-image-#{mention.image.id}']")
    end

    it "mention's modal screenshot has link" do
      expect(page).to have_link('Перейти к материалу', href: mention.url)
    end
  end
end
