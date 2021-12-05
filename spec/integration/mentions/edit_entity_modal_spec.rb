# frozen_string_literal: true

require 'rails_helper'

describe MentionsController, type: :system, responsible: :admin do
  let(:mention) { create(:mention, user: Current.responsible, image_data: image_data) }
  let(:entity) { mention.entities.first }
  let(:image_data) do
    ImageUploader.upload(File.open('spec/fixtures/files/jessa_rhodes.jpg', 'rb'), :store).as_json
  end

  before do
    login_as(Current.responsible, scope: :user)
    visit edit_mention_path(mention, locale: :ru)
  end

  context 'when clicks on edit pen button' do
    it 'opens modal "edit" window' do
      expect(page).not_to have_css('.modal')
      click_on("edit_entity_#{entity.id}")
      expect(page).to have_css('.modal')
      expect(page).to have_text('Редактирование объекта упоминания')
    end
  end
end
