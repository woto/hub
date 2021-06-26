# frozen_string_literal: true

require 'rails_helper'

describe 'Transactions shared columns', type: :system do
  it_behaves_like 'shared columns invisible by default' do
    let(:path) { transactions_path(locale: :ru) }
    let(:object) do
      create(:transaction,
             debit: Account.for_user(user, :pending_post, :rub),
             credit: Account.for_subject('hub', :pending_post, :rub))
    end
    let(:column_id) { 'transaction_group_kind' }
    let(:select_title) { 'Transaction Group Kind' }
    let(:column_title) { 'Transaction Group Kind' }
    let(:column_value) { 'Accounting/Main/Change Status' }
  end

  it_behaves_like 'shared columns visible only to admin' do
    let(:credit_account) { Account.for_subject('hub', :pending_post, :rub) }
    let(:debit_account) { Account.for_user(user, :pending_post, :rub) }
    let(:path) { transactions_path({ cols: '0.7', order: :desc, per: 20, sort: :id, locale: :ru }) }
    let(:object) { create(:transaction, debit: debit_account, credit: credit_account) }
    let(:column_id) { 'credit_id' }
    let(:select_title) { 'Credit' }
    let(:column_title) { 'Credit' }
    let(:column_value) { credit_account.id }
  end
end
