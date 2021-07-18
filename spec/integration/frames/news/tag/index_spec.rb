# frozen_string_literal: true

require 'rails_helper'

describe 'Frames::Articles::TagController#index', type: :system, responsible: :admin do
  before do
    # article1
    create(:post, realm_kind: :news, realm_locale: 'en-US', tags: ['', 'tag 1', 'tag 2'], status: :accrued_post)
    # article2
    create(:post, realm_kind: :news, realm_locale: 'en-US', tags: ['', 'tag 2'], status: :accrued_post)
    # article4 - Russian
    create(:post, realm_kind: :news, realm_locale: 'ru', tags: ['', 'tag 3'], status: :accrued_post)
    # article5 - Article from the feature
    create(:post, realm_kind: :news, realm_locale: 'en-US', tags: ['', 'future'], published_at: 1.minute.from_now,
                  status: :accrued_post)
  end

  it 'displays only article which matches the filter' do
    switch_realm(Realm.pick(locale: 'en-US', kind: :news)) do
      visit '/frames/articles/tag?order=order&per=per&sort=sort'
    end

    expect(page).to have_link(count: 2)
    expect(page).to have_link('tag 1 1', href: '/tag/tag%201?order=order&per=per&sort=sort')
    expect(page).to have_link('tag 2 2', href: '/tag/tag%202?order=order&per=per&sort=sort')
  end

  context 'when time is in future' do
    it 'displays only articles which matches the filter' do
      travel 2.minutes do
        switch_realm(Realm.pick(locale: 'en-US', kind: :news)) do
          visit '/frames/articles/tag'
        end

        expect(page).to have_link(count: 3)
        expect(page).to have_link('tag 1 1', href: '/tag/tag%201')
        expect(page).to have_link('tag 2 2', href: '/tag/tag%202')
        expect(page).to have_link('future', href: '/tag/future')
      end
    end
  end

  context 'when tag is passed in params' do
    it 'highlights the tag' do
      switch_realm(Realm.pick(locale: 'en-US', kind: :news)) do
        visit '/frames/articles/tag?tag=tag%202&order=order&per=per&sort=sort'
      end
      expect(page).to have_css('.active', text: "tag 2\n2")
    end
  end

  context 'when requested realm with ru local' do
    it 'shows 1 link' do
      switch_realm(Realm.pick(locale: 'ru', kind: :news)) do
        visit '/frames/articles/tag?order=order&per=per&sort=sort'
      end

      expect(page).to have_link(count: 1)
      expect(page).to have_link('tag 3', href: '/tag/tag%203?order=order&per=per&sort=sort')
    end
  end
end
