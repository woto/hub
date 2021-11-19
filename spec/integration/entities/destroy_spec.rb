# frozen_string_literal: true

require 'rails_helper'

describe EntitiesController, responsible: :admin, type: :system do
  def open_page
    login_as(Current.responsible, scope: :user)
    visit entities_path(locale: 'ru')
  end

  context 'when entity has mentions' do
    before do
      create(:mention, entities: [create(:entity)])
      open_page
    end

    it "can't be destroyed" do
      expect do
        click_on('Управление')
        accept_confirm { click_on('Удалить') }
        expect(page).to have_text('Невозможно удалить запись, так как существуют зависимости: entities mentions')
      end.to not_change(Entity, :count).and not_change(EntitiesMention, :count)
    end
  end

  context 'when entity does not have mentions' do
    before do
      create(:entity)
      open_page
    end

    it 'can be destroyed' do
      expect do
        click_on('Управление')
        accept_confirm { click_on('Удалить') }
        expect(page).to have_text('Объект упоминания был успешно удален')
      end.to change(Entity, :count).by(-1)
    end
  end
end
