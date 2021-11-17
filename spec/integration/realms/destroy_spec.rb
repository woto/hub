# frozen_string_literal: true

require 'rails_helper'

describe RealmsController, responsible: :admin, type: :system do
  let!(:realm) { create(:realm, kind: :post) }

  before do
    login_as(Current.responsible, scope: :user)
    visit realms_path(locale: 'ru')
  end

  context 'when realm has post_categories' do
    before do
      create(:post_category, realm: realm)
    end

    it "can't be destroyed" do
      expect do
        click_on('Управление')
        accept_confirm { click_on('Удалить') }
        expect(page).to have_text('Невозможно удалить запись, так как существуют зависимости: post categories')
      end.not_to change(Realm, :count)
    end
  end

  context 'when realm does not have children associations' do
    it 'can be destroyed' do
      expect do
        click_on('Управление')
        accept_confirm { click_on('Удалить') }
        expect(page).to have_text('Площадка была успешно удалена')
      end.to change(Realm, :count).by(-1)
    end
  end
end
