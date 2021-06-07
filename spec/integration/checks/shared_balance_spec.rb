# frozen_string_literal: true

require 'rails_helper'

describe ChecksController, type: :system, responsible: :user do
  describe 'GET /checks/:id' do
    it_behaves_like 'shared_balance' do
      let(:check) { create(:check, user: Current.responsible, currency: :rub, amount: 10, status: :pending_check) }
      let(:user) { Current.responsible }
      let(:link) { check_path(id: check, locale: 'ru') }
      let(:balance) { '₽122,00' }
      let(:pending_balance) { '₽15,00' }
      let(:approved_balance) { '₽6,00' }
      let(:payed_balance) { '₽6,00' }
    end
  end

  describe 'GET /checks/new' do
    it_behaves_like 'shared_balance' do
      let(:user) { Current.responsible }
      let(:link) { new_check_path(locale: 'ru') }
      let(:balance) { '₽132,00' }
      let(:pending_balance) { '₽5,00' }
      let(:approved_balance) { '₽6,00' }
      let(:payed_balance) { '₽6,00' }
    end
  end

  describe 'GET /checks/edit/:id' do
    it_behaves_like 'shared_balance' do
      let(:check) { create(:check, user: Current.responsible, currency: :rub, amount: 10, status: :pending_check) }
      let(:user) { Current.responsible }
      let(:link) { edit_check_path(id: check, locale: 'ru') }
      let(:balance) { '₽122,00' }
      let(:pending_balance) { '₽15,00' }
      let(:approved_balance) { '₽6,00' }
      let(:payed_balance) { '₽6,00' }

    end
  end

  describe 'GET /dashboard' do
    it_behaves_like 'shared_balance' do
      let(:user) { Current.responsible }
      let(:link) { dashboard_path(locale: 'ru') }
      let(:balance) { '₽132,00' }
      let(:pending_balance) { '₽5,00' }
      let(:approved_balance) { '₽6,00' }
      let(:payed_balance) { '₽6,00' }
    end
  end
end
