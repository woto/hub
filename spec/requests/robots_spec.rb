require 'rails_helper'

RSpec.describe "Robots", type: :request do
  describe "GET /robots.txt" do
    let(:realm) { create(:realm) }

    before do
      get robots_url(host: realm.domain)
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it 'returns robots.txt with valid sitemap' do
      expect(response.body).to eq("Sitemap: http://#{realm.domain}/sitemaps/#{realm.domain}/sitemap.xml.gz\n")
    end
  end
end