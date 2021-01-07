# frozen_string_literal: true

require 'rails_helper'

describe Frames::News::TagController do
  describe '#index' do
    before do
      # news1
      create(:post, realm_kind: :news, realm_locale: 'en-US', tags: ['tag 1', 'tag 2'])
      # news2
      create(:post, realm_kind: :news, realm_locale: 'en-US', tags: ['tag 2'])
      # news4 - Russian
      create(:post, realm_kind: :news, realm_locale: 'ru', tags: ['tag 3'])
      # news5 - News from the feature
      create(:post, realm_kind: :news, realm_locale: 'en-US', tags: ['future'], published_at: 1.minute.from_now)
    end

    it 'displays only news which matches the filter' do
      visit '/en-US/frames/news/tag?order=order&per=per&sort=sort'

      expect(page).to have_link(count: 2)
      expect(page).to have_link('tag 1 1', href: '/en-US/news/tag/tag%201?order=order&per=per&sort=sort')
      expect(page).to have_link('tag 2 2', href: '/en-US/news/tag/tag%202?order=order&per=per&sort=sort')
    end

    context 'when time is in future' do
      it 'displays only news which matches the filter' do
        travel 2.minute do
          visit '/en-US/frames/news/tag?order=order&per=per&sort=sort'

          expect(page).to have_link(count: 3)
          expect(page).to have_link('tag 1 1', href: '/en-US/news/tag/tag%201?order=order&per=per&sort=sort')
          expect(page).to have_link('tag 2 2', href: '/en-US/news/tag/tag%202?order=order&per=per&sort=sort')
          expect(page).to have_link('future', href: '/en-US/news/tag/future?order=order&per=per&sort=sort')
        end
      end
    end


    it 'highlights the tag if it is passed' do
      visit '/en-US/frames/news/tag?tag=tag%202&order=order&per=per&sort=sort'

      expect(page).to have_css('.active', text: "tag 2\n2")
    end

    context 'when requested another realm with another locale (ru locale)' do
      it 'shows 1 link' do
        visit '/ru/frames/news/tag?order=order&per=per&sort=sort'

        expect(page).to have_link(count: 1)
        expect(page).to have_link('tag 3', href: '/ru/news/tag/tag%203?order=order&per=per&sort=sort')
      end
    end
  end
end
