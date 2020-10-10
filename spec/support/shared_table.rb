# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'shared_table' do |class_name|

  it 'shows 1 item on 3rd page', browser: :desktop do
    visit "/#{plural}?page=3&per=5"
    expect(page).to have_css(".table_#{singular}", count: 1)
  end

  it 'respects page param and visits second page', browser: :desktop do
    visit "/#{plural}?per=5"
    expect(page).to have_css(".table_#{singular}", count: 5)

    find('#pagination_3 a').click
    expect(page).to have_css(".table_#{singular}", count: 1)
  end

  it 'does not show other pages except current', browser: :mobile do
    visit "/#{plural}?per=5&page=2"
    expect(page).to have_no_css('#pagination_1 a')
    expect(page).to have_css('#pagination_2 a')
    expect(page).to have_no_css('#pagination_3 a')
  end

  it 'shows navigation links on desktop', browser: :desktop do
    visit "/#{plural}?per=5&page=2"
    expect(page).to have_css('#pagination_first')
    expect(page).to have_css('#pagination_previous')
    expect(page).to have_css('#pagination_next')
    expect(page).to have_css('#pagination_last')
  end

  it 'does not show pagination when items amount less than per', browser: :desktop do
    "/#{plural}?per=100"
    expect(page).to have_no_css('.pagination')
  end

  it 'shows pagination when items amount more than per', browser: :desktop do
    visit "/#{plural}?per=5"
    expect(page).to have_css('.pagination')
  end

  it 'changes per page items', browser: :desktop do
    visit "/#{plural}?per=5"
    expect(page).to have_css(".table_#{singular}", count: 5)

    page.select '20', from: 'capybara-perselect'
    expect(page).to have_css(".table_#{singular}", count: 11)
  end

  it 'preselects select option with corresponding per value', browser: :desktop do
    visit "/#{plural}?per=5"
    expect(page).to have_select('capybara-perselect', selected: '5')

    visit "/#{plural}?per=20"
    expect(page).to have_select('capybara-perselect', selected: '20')
  end

  it 'shows correct entries info', browser: :desktop do
    visit "/#{plural}?per=5&page=2"
    expect(page).to have_text('6 - 10 of 11')
  end

  context 'with search bar' do
    options = [
      { browser: :desktop, selector: '.content' },
      { browser: :mobile, selector: 'aside' }
    ]

    options.each do |opts|
      it "searches by clicking on search button '#{opts[:browser]}'", browser: opts[:browser] do
        visit "/ru/#{plural}"
        within(opts[:selector]) do
          fill_in 'Введите текст для поиска...', with: objects.last.id
          click_button 'search-button'
          has_correct_search_path(plural: plural, q: objects.last.id)
        end
      end

      it "searches by pressing Enter on keyboard '#{opts[:browser]}'", browser: opts[:browser] do
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
