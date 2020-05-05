require "rails_helper"

RSpec.describe "Widget management", :type => :system do
  before do
    driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
  end

  it "enables me to create widgets" do
    visit "/dashboard"
    click_link "Language"

    expect(page).to have_text("English")
  end
end
