# frozen_string_literal: true

require 'rails_helper'

describe 'PostCategories shared workspace', type: :system do
  it_behaves_like 'shared workspace authenticated' do
    let(:cols) { '0.30.3' }
    let(:plural) { 'post_categories' }
    let(:user) { create(:user) }
  end

  it_behaves_like 'shared workspace unauthenticated' do
    before do
      create(:post_category)
      visit '/ru/post_categories'
    end
  end
end
