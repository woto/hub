# frozen_string_literal: true

require 'rails_helper'

describe 'ArticlesController#show', type: :system, responsible: :admin do
  let!(:article) do
    create(:post,
           post_category: child_post_category,
           published_at: Time.zone.parse('2020-04-07 02:00'), tags: %w[tag1 tag2])
  end
  let(:ru_realm) { Realm.pick(kind: :news, locale: :ru, domain: 'realm-ru.lvh.me') }
  let!(:en_realm) { Realm.pick(kind: :news, locale: :en) }
  let(:parent_post_category) { create(:post_category, realm: ru_realm) }
  let(:child_post_category) { create(:post_category, realm: ru_realm, parent: parent_post_category) }

  before do
    switch_realm(article.realm) do
      visit article_path(id: article, per: 1, page: 1, sort: :created_at, order: :asc)
    end
  end

  it 'has correct title' do
    expect(page).to have_css('h1', text: article.title)
  end

  it 'has correct breadcrumbs' do
    expect(page).to have_link(parent_post_category.to_label,
                              href: articles_by_category_path(
                                category_id: parent_post_category.id, per: 1, sort: :created_at, order: :asc
                              ))

    expect(page).to have_link(child_post_category.to_label,
                              href: articles_by_category_path(
                                category_id: child_post_category.id, per: 1, sort: :created_at, order: :asc
                              ))
  end

  it 'has correct subtitle' do
    expect(page).to have_css('h2', text: article.title)
  end

  it 'has correct body' do
    expect(page).to have_css('.articles-body', text: article.body.to_plain_text)
  end

  it 'has correct publication date' do
    expect(page).to have_css('.articles-date', text: ApplicationController.helpers.l(
      article.published_at.to_date, locale: 'ru'
    ))
  end

  it 'shows article tag links with correct href' do
    within("[data-test-id='articles-card-#{article.id}']") do
      expect(page).to have_link(article.tags.first, href: articles_by_tag_path(
        tag: article.tags.first, per: 1, sort: :created_at, order: :asc
      ))
    end
  end

  it 'shows "Back to articles" link with correct href' do
    within("[data-test-id='articles-card-#{article.id}']") do
      expect(page).to have_link('Назад к новостям', href: articles_path(
        per: 1, sort: :created_at, order: :asc
      ))
    end
  end

  it 'has correct switch to english language link' do
    click_on('Язык')
    expect(page).to have_link('English', href: articles_url(host: en_realm.domain,
                                                                    port: Capybara.current_session.server.port))
  end

  it 'has correct articles-by-month turbo-frame' do
    src = frames_articles_month_path(per: 1, sort: :created_at, order: :asc)
    expect(page).to have_css("turbo-frame#articles-by-month[src='#{src}']", visible: :all)
  end

  it 'has correct articles-by-tag turbo-frame' do
    src = frames_articles_tag_path(per: 1, sort: :created_at, order: :asc)
    expect(page).to have_css("turbo-frame#articles-by-tag[src='#{src}']", visible: :all)
  end

  it 'has correct articles-by-category turbo-frame' do
    src = frames_articles_category_path(per: 1, sort: :created_at, order: :asc)
    expect(page).to have_css("turbo-frame#articles-by-category[src='#{src}']", visible: :all)
  end

  context "when clicks on form's search" do
    it 'follows to correct page' do
      fill_in('Введите текст для поиска...', with: 'foo')
      click_on('Искать')
      path = articles_path(per: 1, sort: :created_at, order: :asc, q: 'foo')
      expect(page).to have_current_path(path)
    end
  end
end
