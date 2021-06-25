# frozen_string_literal: true

require 'rails_helper'

describe 'Accounts shared columns', type: :system do
  let(:path) { accounts_path(locale: :ru) }
  let(:user) { create(:user) }

  it_behaves_like 'shared columns invisible by default' do
    let(:object) { Account.for_user(user, :pending_post, :rub) }
    let(:select_title) { 'Валюта' }
    let(:column_title) { 'Валюта' }
    let(:column_value) { 'rub' }
  end

  # it_behaves_like 'shared columns visible only to admin' do
  #   let(:object) { Account.for_user(user, :pending_post, :rub) }
  #   let(:column_title) { :subjectable_id }
  #   let(:column_value) { :subjectable_id }
  # end
end
