# frozen_string_literal: true

require 'rails_helper'

describe Tables::ArticlesController, type: :system do
  let!(:realm) { create(:realm, key: :'en-US', kind: :news) }

  describe 'GET /articles/month/:month' do
    it_behaves_like 'shared_language_component' do
      before do
        switch_realm(create(:realm, key: :ru)) do
          visit articles_by_month_path('2020-04')
        end
      end

      let(:link) { articles_url(host: realm.domain, port: Capybara.current_session.server.port) }
    end
  end

  describe 'GET /articles/tag/:tag' do
    it_behaves_like 'shared_language_component' do
      before do
        switch_realm(create(:realm, key: :ru)) do
          visit articles_by_tag_path(tag: 'tag')
        end
      end

      let(:link) { articles_url(host: realm.domain, port: Capybara.current_session.server.port) }
    end
  end

  describe 'GET /articles' do
    it_behaves_like 'shared_language_component' do
      before do
        switch_realm(create(:realm, key: :ru)) do
          visit articles_path
        end
      end

      let(:link) { articles_url(host: realm.domain, port: Capybara.current_session.server.port) }
    end
  end
end
