require "rails_helper"

RSpec.describe "Tawk" do

  before do
    allow(ENV).to receive(:[]).and_call_original
  end

  context "when TAWK_ENABLED == 'true'" do
    before do
      allow(ENV).to receive(:[]).with("TAWK_ENABLED").and_return("true")
    end

    it "shows tawk widget" do
      get '/dashboard'
      expect(response.body).to match('Tawk_API')
    end
  end

  context "when TAWK_ENABLED == 'false'" do
    before do
      allow(ENV).to receive(:[]).with("TAWK_ENABLED").and_return("false")
    end

    it 'does not show tawk widget' do
      get '/dashboard'
      expect(response.body).not_to match('Tawk_API')
    end
  end
end
