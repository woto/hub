# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'shared_table' do |class_name, flag|
  singular = class_name.name.underscore
  plural = singular.pluralize

  before do
    login_as(user, scope: :user) if flag
  end

  let(:user) do
    create(:user) if flag
  end

  context "when #{singular} is present" do
    let(:object) { flag ? create(singular, user: user) : create(singular) }

    before do
      object
      class_name.__elasticsearch__.refresh_index!
    end

    it "shows #{singular}", browser: :desktop do
      visit "/#{plural}"
      expect(page).to have_css("#table_#{singular}_#{object.id}")
    end
  end

  context "when #{plural} are absent" do
    it 'shows blank page', browser: :desktop do
      class_name.__elasticsearch__.create_index!
      visit "/#{plural}"
      expect(page).to have_text('No results found')
    end
  end

  context "when #{plural} are present" do
    let(:objects) { flag ? create_list(singular, 11, user: user) : create_list(singular, 11) }

    before do
      objects
      class_name.__elasticsearch__.refresh_index!
    end

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
      page.has_select?('capybara-perselect', selected: '5')
      visit "/#{plural}?per=20"
      page.has_select?('capybara-perselect', selected: '20')
    end

    it 'shows correct entries info', browser: :desktop do
      visit "/#{plural}?per=5&page=2"
      expect(page).to have_text('6 - 10 of 11')
    end

  end
end
