# frozen_string_literal: true

require 'rails_helper'

describe 'Users shared workspace', type: :system do
  it_behaves_like 'shared workspace authenticated' do
    let(:cols) { '0.6' }
    let(:plural) { 'users' }
    let(:user) { create(:user, role: 'admin') }
  end
end
