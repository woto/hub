# frozen_string_literal: true

require 'rails_helper'

describe 'Checks shared workspace', type: :system do
  it_behaves_like 'shared workspace authenticated' do
    let(:cols) { '0.30.3' }
    let(:plural) { 'checks' }
    let(:user) { create(:user) }
  end
end
