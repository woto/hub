# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboard' do
  let!(:user) { create(:user) }
  let!(:exchange_rate) { create(:exchange_rate) }

  describe '#index' do
    subject! { visit '/ru/dashboard' }

    describe 'language_component' do
      it_behaves_like 'shared language_component' do
        let(:link) { dashboard_path(locale: 'en') }
      end
    end

    it 'renders latest-news frame' do
      expect(page).to have_css('turbo-frame#latest-news[src="/ru/frames/news/latest"]')
    end

    context 'when user is not authenticated' do
      pending
    end

    context 'when user is authenticated' do
      pending
    end
  end
end
