# frozen_string_literal: true

require 'rails_helper'

describe DashboardController, type: :system do
  before do
    user = create(:user, role: :admin)
    login_as(user, scope: :user)
  end

  shared_examples 'highlight active' do
    let(:flat) do
      lambda {
        within '#navbar-menu' do
          link = find_link(title, href: href)
          parent = link.find(:xpath, '..')
          expect(parent).to be_matches_css('.active'), "#{title} should be highlighted"
        end
      }
    end

    let(:nested) do
      lambda {
        within '#navbar-menu' do
          link = find_link(title, href: href)
          expect(link).to be_matches_css('.active'), "#{title} should be highlighted"
          ancestor = link.find(:xpath, '..')
          ancestor = ancestor.find(:xpath, '..')
          ancestor = ancestor.find(:xpath, '..')
          expect(ancestor).to be_matches_css('.active'), "#{title} ancestor should be highlighted"
        end
      }
    end

    it 'highlight active' do
      visit url
      send(checker).call
    end

    #   not_highlighteds.each do |not_highlighted|
    #     link = find_link(not_highlighted[:title], href: not_highlighted[:href], visible: :all)
    #     parent_li = link.find(:xpath, '..')
    #     expect(parent_li).to be_not_matches_css('.active'), "#{title} should NOT be highlighted"
    #   end
    # end
  end

  describe 'highlight "Дашборд"' do
    it_behaves_like 'highlight active' do
      let(:url) { '/ru/dashboard' }
      let(:href) { '/ru/dashboard' }
      let(:title) { 'Дашборд' }
      let(:checker) { :flat }
    end
  end

  describe 'highlight "Прайс листы"' do
    it_behaves_like 'highlight active' do
      let(:url) { '/ru/feeds' }
      let(:href) { '/ru/feeds' }
      let(:title) { 'Прайс листы' }
      let(:checker) { :flat }
    end
  end

  describe 'highlight "Товары"' do
    it_behaves_like 'highlight active' do
      let(:url) { '/ru/offers' }
      let(:href) { '/ru/offers' }
      let(:title) { 'Товары' }
      let(:checker) { :flat }
    end
  end

  describe 'highlight "Статьи"' do
    it_behaves_like 'highlight active' do
      let(:url) { '/ru/posts' }
      let(:href) { '/ru/posts' }
      let(:title) { 'Статьи' }
      let(:checker) { :flat }
    end
  end

  describe 'highlight "Пользователи"' do
    it_behaves_like 'highlight active' do
      let(:url) { '/ru/users' }
      let(:href) { '/ru/users' }
      let(:title) { 'Пользователи' }
      let(:checker) { :flat }
    end
  end

  describe 'highlight "Транзакции"' do
    it_behaves_like 'highlight active' do
      let(:url) { '/ru/transactions' }
      let(:href) { '/ru/transactions' }
      let(:title) { 'Транзакции' }
      let(:checker) { :nested }
    end
  end

  describe 'highlight "Счета"' do
    it_behaves_like 'highlight active' do
      let(:url) { '/ru/accounts' }
      let(:href) { '/ru/accounts' }
      let(:title) { 'Счета' }
      let(:checker) { :nested }
    end
  end

  describe 'highlight "Запросы выплат"' do
    it_behaves_like 'highlight active' do
      let(:url) { '/ru/checks' }
      let(:href) { '/ru/checks' }
      let(:title) { 'Запросы выплат' }
      let(:checker) { :nested }
    end
  end

  describe 'highlight "Профиль"' do
    it_behaves_like 'highlight active' do
      let(:url) { '/ru/settings/profile' }
      let(:href) { '/ru/settings/profile' }
      let(:title) { 'Настройки' }
      let(:checker) { :flat }
    end
  end

  describe 'highlight "Пароль"' do
    it_behaves_like 'highlight active' do
      let(:url) { '/ru/settings/password' }
      let(:href) { '/ru/settings/profile' }
      let(:title) { 'Настройки' }
      let(:checker) { :flat }
    end
  end

  describe 'highlight "Почта"' do
    it_behaves_like 'highlight active' do
      let(:url) { '/ru/settings/email' }
      let(:href) { '/ru/settings/profile' }
      let(:title) { 'Настройки' }
      let(:checker) { :flat }
    end
  end

  describe 'highlight "Опасная зона"' do
    it_behaves_like 'highlight active' do
      let(:url) { '/ru/settings/danger_zone' }
      let(:href) { '/ru/settings/profile' }
      let(:title) { 'Настройки' }
      let(:checker) { :flat }
    end
  end

  describe 'highlight "Новости"' do
    it_behaves_like 'highlight active' do
      let(:url) { '/ru/news' }
      let(:href) { '/ru/news' }
      let(:title) { 'Новости' }
      let(:checker) { :flat }
    end
  end

  describe 'highlight "Справка"' do
    it_behaves_like 'highlight active' do
      let(:url) { '/ru/help' }
      let(:href) { '/ru/help' }
      let(:title) { 'Справка' }
      let(:checker) { :flat }
    end
  end
end
