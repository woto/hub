# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Widget management', type: :system do
  it 'enables me to create widgets', browser: :mobile do
    visit '/dashboard'
    click_link 'Language'
    expect(page).to have_text('English')
  end
end
