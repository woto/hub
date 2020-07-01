require "rails_helper"

RSpec.describe "Tawk" do

  before do
    allow(ENV).to receive(:[]).and_call_original
  end

  context "when TAWK_ENABLED == 'true'" do
    before do
      allow(ENV).to receive(:[]).with("TAWK_ENABLED").and_return("true")
    end

    it "shows widget " do
      visit "/dashboard"
      expect(page).to have_css('iframe[title="chat widget"]')
    end
  end

  context "when TAWK_ENABLED == 'false'" do
    before do
      allow(ENV).to receive(:[]).with("TAWK_ENABLED").and_return("false")
    end

    it "does not show widget " do
      visit "/dashboard"
      expect(page).not_to have_css('iframe[title="chat widget"]')
    end
  end
end
