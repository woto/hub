# frozen_string_literal: true

require 'rails_helper'

describe 'Feeds shared workspace', type: :system do
  it_behaves_like 'shared workspace authenticated' do
    let(:cols) { '0.30.3' }
    let(:plural) { 'feeds' }
    let(:user) { create(:user) }
  end

  it_behaves_like 'shared workspace unauthenticated' do
    before do
      create(:feed)
      visit '/ru/feeds'
    end
  end
end
