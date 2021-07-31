# frozen_string_literal: true

require 'rails_helper'

describe Tables::FeedsController, type: :system do
  before do
    visit feeds_path(q: 'a', per: 5, page: 10, sort: 'id', order: 'asc', columns: %w[id name],
                     filters: { id: { min: 1, max: 10 } }, trash: 'trash', locale: 'ru')
  end

  it 'has link to the first page with direct sort order by id' do
    expect(page).to(
      have_link(
        'sort_id',
        href: feeds_path(q: 'a', per: 5, page: 1, sort: 'id', order: 'desc',
                         columns: %w[id name], filters: { id: { min: 1, max: 10 } }, locale: 'ru')
      )
    )
  end

  it 'has link to the first page with reverse sort order by name' do
    expect(page).to(
      have_link(
        'sort_name.keyword',
        href: feeds_path(q: 'a', per: 5, page: 1, sort: 'name.keyword', order: 'desc',
                         columns: %w[id name], filters: { id: { min: 1, max: 10 } }, locale: 'ru')
      )
    )
  end
end
