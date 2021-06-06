# frozen_string_literal: true

require 'rails_helper'

describe Tables::ChecksController, type: :system, responsible: :user do
  before do
    allow_any_instance_of(Check).to receive(:check_amount)
  end

  let!(:check) do
    create(:check,
           user: Current.responsible,
           amount: 123.456,
           currency: :rub,
           status: :pending_check,
           created_at: 2.hours.ago,
           updated_at: 1.hour.ago
    )
  end

  context 'with user' do
    it 'shows Check model attributes correctly' do
      login_as(Current.responsible, scope: :user)
      visit check_path(check, locale: :ru)

      within('main') do
        expect(page).to have_text('₽123,46')
        expect(page).to have_text('запрошено')
        expect(page).to have_text('2 часа назад')
        expect(page).to have_text('час назад')

        expect(page).to have_no_text(check.user.to_label)
        expect(page).to have_link('Изменить')
      end
    end
  end

  context 'with another user' do
    it 'returns friendly error' do
      login_as(create(:user), scope: :user)
      visit post_path(check, locale: :ru)

      expect(page).to have_text("The page you were looking for doesn't exist")
    end
  end

  context 'with admin' do
    it 'shows additional fields' do
      login_as(create(:user, role: :admin), scope: :user)
      visit check_path(check, locale: :ru)

      within('main') do
        expect(page).to have_text(check.user.to_label)
      end
    end
  end
end
