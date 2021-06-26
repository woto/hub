# frozen_string_literal: true

require 'rails_helper'

describe 'Accounts shared columns', type: :system do
  it_behaves_like 'shared columns invisible by default' do
    let(:path) { accounts_path(locale: :ru) }
    let(:object) { Account.for_user(user, :pending_post, :rub) }
    let(:column_id) { 'currency' }
    let(:select_title) { 'Валюта' }
    let(:column_title) { 'Валюта' }
    let(:column_value) { 'rub' }
  end

  it_behaves_like 'shared columns visible only to admin' do
    let(:path) { accounts_path({ cols: '0.6', order: :desc, per: 20, sort: :id, locale: :ru }) }
    let(:object) { Account.for_user(user, :pending_post, :rub) }
    let(:column_id) { 'subjectable_label' }
    let(:select_title) { 'Subjectable Label' }
    let(:column_title) { 'Subjectable Label' }
    let(:column_value) { user.email }
  end
end
