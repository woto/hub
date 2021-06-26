# frozen_string_literal: true

require 'rails_helper'

shared_examples 'shared_table' do |_class_name|
  it 'shows row' do
    objects
    visit "/ru/#{plural}"
    expect(page).to have_css("#table_#{singular}_#{objects.first.id}")
  end

  context 'when there are no items' do
    it 'shows blank page' do
      visit "/ru/#{plural}"
      expect(page).to have_text('%{entry_name.capitalize} не найдено')
    end
  end

  it 'shows 1 item on 3rd page' do
    objects
    visit "/ru/#{plural}?page=3&per=5"
    expect(page).to have_css(".table_#{singular}", count: 1)
  end

  it 'respects page param and visits second page' do
    objects
    visit "/ru/#{plural}?per=5"
    expect(page).to have_css(".table_#{singular}", count: 5)

    find('#pagination_3 a').click
    expect(page).to have_css(".table_#{singular}", count: 1)
  end

  xit 'does not show other pages except current', browser: :mobile do
    # NOTE: this test is outdated. We always show same navigation as on the desktop
    objects
    visit "/ru/#{plural}?per=5&page=2"
    expect(page).to have_no_css('#pagination_1 a')
    expect(page).to have_css('#pagination_2 a')
    expect(page).to have_no_css('#pagination_3 a')
  end

  it 'shows navigation links on desktop' do
    objects
    visit "/ru/#{plural}?per=5&page=2"
    # expect(page).to have_css('#pagination_first')
    expect(page).to have_css('#pagination_previous')
    expect(page).to have_css('#pagination_next')
    # expect(page).to have_css('#pagination_last')
  end

  it 'does not show pagination when items amount less than per' do
    objects
    "/ru/#{plural}?per=100"
    expect(page).to have_no_css('.pagination')
  end

  it 'shows pagination when items amount more than per' do
    objects
    visit "/ru/#{plural}?per=5"
    expect(page).to have_css('.pagination')
  end

  it 'changes per page items' do
    objects
    visit "/ru/#{plural}?per=5"
    expect(page).to have_css(".table_#{singular}", count: 5)

    page.select '20', from: 'capybara-perselect'
    expect(page).to have_css(".table_#{singular}", count: 11)
  end

  it 'preselects select option with corresponding per value' do
    objects
    visit "/ru/#{plural}?per=5"
    expect(page).to have_select('capybara-perselect', selected: '5')

    visit "/ru/#{plural}?per=20"
    expect(page).to have_select('capybara-perselect', selected: '20')
  end

  it 'shows correct entries info' do
    objects
    visit "/ru/#{plural}?per=5&page=2"
    expect(page).to have_text('Отображение 6 - 10 из 11 всего')
  end

  context 'with search bar' do
    options = [
      { browser: :desktop, selector: 'header' },
      { browser: :mobile, selector: 'aside' }
    ]

    options.each do |opts|
      it "searches by clicking on search button '#{opts[:browser]}'", browser: opts[:browser] do
        objects
        visit "/ru/#{plural}"
        within(opts[:selector]) do
          fill_in 'Введите текст для поиска...', with: objects.last.id
          click_button 'Искать'
          has_correct_search_path(plural: plural, q: objects.last.id)
        end
      end

      it "searches by pressing Enter on keyboard '#{opts[:browser]}'", browser: opts[:browser] do
        objects
        visit "/ru/#{plural}"
        within(opts[:selector]) do
          fill_in 'Введите текст для поиска...', with: objects.last.id
          find('.search-text').send_keys :enter
          has_correct_search_path(plural: plural, q: objects.last.id)
        end
      end
    end

    def has_correct_search_path(plural:, q:)
      expect(page).to have_current_path(
        url_for(controller: plural, action: :index, locale: 'ru', only_path: true),
        url: false, ignore_query: true
      )
      expect(::Addressable::URI.parse(current_url).query_values).to include('q' => q.to_s)
    end
  end
end
