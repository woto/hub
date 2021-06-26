# frozen_string_literal: true

require 'rails_helper'

describe 'Favorites shared workspace', type: :system do
  it_behaves_like 'shared workspace authenticated' do
    let(:cols) { '0.30.3' }
    let(:plural) { 'favorites' }
    let(:user) { create(:user) }
  end
end
