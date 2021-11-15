# frozen_string_literal: true

require 'rails_helper'

describe APIDocsController, type: :system do
  describe '#index' do
    it 'shows page to not authorized users' do
      visit '/api_docs'
      expect(page).to have_text('API title')
      expect(page).to have_text('0.0.1')
    end
  end
end
