# frozen_string_literal: true

require 'rails_helper'

describe DashboardController, type: :system do
  describe 'shared_language_component' do
    it_behaves_like 'shared_language_component' do
      before do
        visit '/ru/dashboard'
      end

      let(:link) { dashboard_path(locale: 'en') }
    end
  end

  describe '#index' do
    describe 'TODO' do
      context 'renders latest-news frame' do
        before do
          visit '/ru/dashboard'
        end

        it 'renders latest-news frame' do
          expect(page).to have_css('turbo-frame#latest-news[src="/ru/frames/news/latest"]')
        end
      end
    end
  end
end
