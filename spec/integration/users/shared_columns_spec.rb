# frozen_string_literal: true

require 'rails_helper'

describe 'Users shared columns', type: :system do
  let(:path) { users_path(locale: :ru) }
  let(:user) { create(:user, role: :admin) }

  it_behaves_like 'shared columns invisible by default' do
    let(:object) {}
    let(:select_title) { 'Role' }
    let(:column_title) { 'Role' }
    let(:column_value) { 'admin' }
  end
end
