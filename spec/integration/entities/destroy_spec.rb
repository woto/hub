# frozen_string_literal: true

require 'rails_helper'

describe EntitiesController, responsible: :admin, type: :system do
  let!(:entity) { create(:entity) }
  let(:title) { "№ #{entity.id}" }

  def open_page
    login_as(Current.responsible, scope: :user)
    visit entities_path(locale: 'ru')
  end

  context 'when entity has mentions' do
    let!(:mention) { create(:mention, entities: [entity]) }

    it "can't be destroyed" do
      open_page

      expect do
        click_on(title)
        accept_confirm { click_on('Удалить') }
        expect(page).to have_text('Невозможно удалить запись, так как существуют зависимости: entities mentions')
      end.to not_change(Entity, :count).and not_change(EntitiesMention, :count)
    end
  end

  context 'when entity does not have mentions' do
    it 'can be destroyed' do
      open_page

      expect do
        click_on(title)
        accept_confirm { click_on('Удалить') }
        expect(page).to have_text('Объект упоминания был успешно удален')
      end.to change(Entity, :count).by(-1)
    end
  end
end
