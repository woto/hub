# frozen_string_literal: true

require 'rails_helper'

describe Tables::NewsController, type: :system do

  describe 'GET /news/month/:month' do
    it_behaves_like 'shared_language_component' do
      before do
        visit by_month_news_index_path('2020-04')
      end

      let(:link) { news_index_path(locale: 'en') }
    end
  end

  describe 'GET /news/tag/:tag' do
    it_behaves_like 'shared_language_component' do
      before do
        visit by_tag_news_index_path({ tag: 'tag', locale: 'ru' })
      end

      let(:link) { news_index_path(locale: 'ru') }
    end
  end

  describe 'GET /news' do
    it_behaves_like 'shared_language_component' do
      before do
        visit news_index_path
      end

      let(:link) { news_index_path(locale: 'en') }
    end
  end
end
