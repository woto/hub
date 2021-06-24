# frozen_string_literal: true

require 'rails_helper'

shared_examples 'shared_search_everywhere', responsible: :admin do
  let(:q) { Faker::Lorem.word }

  it 'clicking on "search everywhere" leads to the correct address' do
    within('section.page') do
      fill_in 'Введите текст для поиска...', with: q
      click_button 'Искать'
      expect(page).to have_current_path(
        url_for(params),
        url: false
      )
    end
  end
end
