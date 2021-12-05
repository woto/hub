# frozen_string_literal: true

require 'rails_helper'

describe MentionsController, type: :system, responsible: :admin do
  let(:mention) { create(:mention, user: Current.responsible, image_data: image_data, entities: [entity]) }
  let(:entity) { create(:entity, lookups: [lookup]) }
  let(:lookup) { create(:lookup, title: 'Lookup title') }
  let(:image_data) do
    ImageUploader.upload(File.open('spec/fixtures/files/jessa_rhodes.jpg', 'rb'), :store).as_json
  end

  before do
    login_as(Current.responsible, scope: :user)
    visit edit_mention_path(mention, locale: :ru)
  end

  context 'when clicks on entity remove' do
    it 'unassigns it' do
      expect(page).to have_css("#card_entity_#{entity.id}")
      expect(page).to have_css("#edit_entity_#{entity.id}")
      expect(page).to have_css("#remove_entity_#{entity.id}")

      click_on("remove_entity_#{entity.id}")

      expect(page).not_to have_css("#edit_entity_#{entity.id}")
      expect(page).not_to have_css("#remove_entity_#{entity.id}")
    end
  end
end
