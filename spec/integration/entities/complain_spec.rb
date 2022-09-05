# frozen_string_literal: true

require 'rails_helper'

describe EntitiesController, type: :system, responsible: :user do
  subject!(:entity) { create(:entity) }

  context 'when form successfully submitted' do
    before do
      visit entity_path(entity)
      click_on('Репорт')
      fill_in('text', with: 'text')
    end

    it 'thanks user with success text' do
      click_on('Отправить')
      expect(page).to have_text('Благодарим вас за отправку отчета.')
    end

    it 'creates new record in database' do
      expect do
        click_on('Отправить')
        expect(page).to have_text('Благодарим вас за отправку отчета.')
      end.to change(Complain, :count)
    end

    it 'stores text and entity_id in database' do
      click_on('Отправить')
      expect(page).to have_text('Благодарим вас за отправку отчета.')
      expect(Complain.last).to have_attributes(text: 'text', data: { 'entity_id' => entity.id })
    end
  end

  context 'when form reopens after filling' do
    it 'does not store previous values' do
      visit entity_path(entity)
      click_on('Репорт')
      fill_in('text', with: 'text')
      expect(page).to have_field('text', with: 'text')
      click_on('Закрыть')
      click_on('Репорт')
      expect(page).not_to have_field('text', with: 'text')
    end
  end

  context 'when form reopens after successful submit' do
    it 'does not store previous values' do
      visit entity_path(entity)
      click_on('Репорт')
      fill_in('text', with: 'text')
      click_on('Отправить')
      expect(page).to have_text('Благодарим вас за отправку отчета.')
      click_on('Закрыть')
      click_on('Репорт')
      expect(page).not_to have_field('text', with: 'text')
    end
  end

  context 'when user is authenticated' do
    it 'stores user' do
      login_as(Current.responsible, scope: :user)
      visit entity_path(entity)
      click_on('Репорт')
      fill_in('text', with: 'text')
      click_on('Отправить')
      expect(page).to have_text('Благодарим вас за отправку отчета.')
      expect(Complain.last.user).to eq(Current.responsible)
    end
  end

  context 'when sends empty form' do
    it 'shows error' do
      visit entity_path(entity)
      click_on('Репорт')
      expect(page).not_to have_text('Поле обязательно для заполнения')
      click_on('Отправить')
      expect(page).to have_text('Поле обязательно для заполнения')
    end
  end

  context 'when server responses with error' do
    it 'shows error' do
      visit entity_path(entity)
      click_on('Репорт')
      fill_in('text', with: 'text')
      allow(Interactors::Complains::CreateInteractor).to receive(:call).and_raise(StandardError)
      click_on('Отправить')
      expect(page).to have_text('Произошла непредвиденная ошибка')
    end
  end
end
