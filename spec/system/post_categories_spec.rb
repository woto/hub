# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PostCategories' do
  let!(:post_category) { create(:post_category) }

  describe '#index' do
    it "has 'Категории' title" do
      visit '/ru/post_categories'
      expect(page).to have_css('h1', text: 'Категории')
    end
  end
end
