# frozen_string_literal: true

require 'rails_helper'

describe 'Accounts shared workspace', type: :system do
  it_behaves_like 'shared workspace authenticated' do
    let(:cols) { '0.30.3' }
    let(:plural) { 'accounts' }
    let(:user) { create(:user) }
  end
end