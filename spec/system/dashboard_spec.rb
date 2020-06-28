require "rails_helper"

RSpec.describe "Widget management", type: :system do
  it "enables me to create widgets" do
    visit "/dashboard"
    click_link "Language"
    expect(page).to have_text("English")
  end

  it 'shows login link' do
    visit "/dashboard"
    expect(page).to have_text('Login')
  end
end
