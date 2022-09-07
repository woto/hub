# frozen_string_literal: true

require 'rails_helper'

describe 'EntitiesController#show', type: :system do
  subject!(:entity) { create(:entity, title: 'title', intro: 'intro') }
  let!(:mention) { create(:mention, entities: [entity]) }
  let!(:images_relation) { create(:images_relation, relation: mention) }

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

  it "shows mention's thumbnail" do
    expect(page).to have_css("[data-test-id='small-image-#{images_relation.image.id}']")
  end

  context "when clicks on the mention's thumbnail" do
    before do
      find("[data-test-id='small-image-#{images_relation.image.id}']").click
    end

    it "shows larger mention's screenshot" do
      expect(page).to have_css("[data-test-id='big-image-#{images_relation.image.id}']")
    end

    it "mention's modal screenshot has link" do
      expect(page).to have_link('Перейти к материалу', href: mention.url)
    end
  end
end
