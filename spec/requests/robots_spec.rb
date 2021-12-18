# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Robots', type: :request do
  context 'when site is a realm' do
    describe 'GET /robots.txt' do
      let(:realm) { create(:realm) }

      before do
        # get robots_url(host: realm.domain)
        get "https://#{realm.domain}/robots.txt"
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns robots.txt with valid sitemap' do
        expect(response.body).to eq("Sitemap: https://#{realm.domain}/sitemaps/#{realm.domain}/sitemap.xml.gz\n")
      end
    end
  end

  context 'when site is a hub' do
    describe 'GET /robots.txt' do
      before do
        # get robots_url(host: realm.domain)
        get "#{root_url}robots.txt"
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns robots.txt with valid sitemap' do
        expect(response.body).to eq("Sitemap: #{root_url}sitemaps/sitemap.xml.gz\n")
      end
    end
  end
end
