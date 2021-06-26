# frozen_string_literal: true

require 'rails_helper'

describe 'Users shared columns', type: :system do
  it_behaves_like 'shared columns invisible by default' do
    let(:user) { create(:user, role: :admin) }
    let(:path) { users_path(locale: :ru) }
    let(:object) { user }
    let(:column_id) { 'role' }
    let(:select_title) { 'Role' }
    let(:column_title) { 'Role' }
    let(:column_value) { 'admin' }
  end

  # NOTE: The page is not available to the users
  # it_behaves_like 'shared columns visible only to admin' do
  #   let(:path) { users_path({ cols: '0.7', order: :desc, per: 20, sort: :id, locale: :ru }) }
  #   let(:object) { user }
  #   let(:column_id) { 'encrypted_password' }
  #   let(:select_title) { 'Encrypted Password' }
  #   let(:column_title) { 'Encrypted Password' }
  #   let(:column_value) { user.encrypted_password }
  # end
end
