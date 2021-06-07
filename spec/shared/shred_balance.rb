# frozen_string_literal: true

require 'rails_helper'

shared_examples 'shared_balance' do
  before do
    result = Account.for_user(user, :accrued_post, :rub)
    Account.where(id: result.id).update_all(amount: 150)
    result = Account.for_user(user, :pending_check, :rub)
    Account.where(id: result.id).update_all(amount: 5)
    result = Account.for_user(user, :approved_check, :rub)
    Account.where(id: result.id).update_all(amount: 6)
    result = Account.for_user(user, :payed_check, :rub)
    Account.where(id: result.id).update_all(amount: 7)
  end

  it 'shows user balances' do
    login_as(user, scope: :user)
    visit link

    expect(page).to have_text(balance)

    click_link('Подробности', href: '#accounts-rub')
    expect(page).to have_text(pending_balance)
    expect(page).to have_text(approved_balance)
    expect(page).to have_text(payed_balance)
  end
end
