# frozen_string_literal: true

require 'rails_helper'

describe 'Transactions shared columns', type: :system do
  let(:path) { transactions_path(locale: :ru) }
  let(:user) { create(:user, role: :admin) }

  it_behaves_like 'shared columns invisible by default' do
    let(:object) do
      create(:transaction, debit: Account.for_user(user, :pending_post, :rub),
                           credit: Account.for_subject('hub', :pending_post, :rub))
    end
    let(:select_title) { 'Transaction Group Kind' }
    let(:column_title) { 'Transaction Group Kind' }
    let(:column_value) { 'Accounting/Main/Change Status' }
  end
end
