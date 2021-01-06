# frozen_string_literal: true

require 'rails_helper'

describe Frames::News::MonthController do
  describe '#index' do
    before do
      # news1
      create(:post, realm_kind: :news, realm_locale: 'en-US', published_at: Time.zone.parse('2020-03-31 22:00'))
      # news2
      create(:post, realm_kind: :news, realm_locale: 'en-US', published_at: Time.zone.parse('2020-04-01 02:00'))
      # news3
      create(:post, realm_kind: :news, realm_locale: 'en-US', published_at: Time.zone.parse('2020-05-10 12:00'))
      # news4 - Russian
      create(:post, realm_kind: :news, realm_locale: 'ru', published_at: 1.minute.ago)
      # news5 - News from the feature
      create(:post, realm_kind: :news, realm_locale: 'en-US', published_at: 1.minute.from_now)
    end

    it 'does not show news from future (finds only news1, news2, news3)' do
      visit '/en-US/frames/news/month'
      expect(page).to have_link(count: 3)
    end

    it 'displays only news which matches the filter (locale en-US, already published)' do
      visit '/en-US/frames/news/month?order=order&per=per&sort=sort'
      expect(page).to have_link('2020 March 1', href: '/en-US/news/month/2020-03?order=order&per=per&sort=sort')
      expect(page).to have_link('2020 April 1', href: '/en-US/news/month/2020-04?order=order&per=per&sort=sort')
      expect(page).to have_link('2020 May 1', href: '/en-US/news/month/2020-05?order=order&per=per&sort=sort')
    end

    it 'highlights the month if it is passed' do
      visit '/en-US/frames/news/month?month=2020-05&order=order&per=per&sort=sort'
      expect(page).to have_css('.active', text: "2020 May\n1")
    end

    context 'when user in Magadan (UTC +11:00)' do
      let(:profile) { create(:profile, time_zone: 'Magadan') }
      let(:user) { create(:user, profile: profile) }

      it 'shows 3 items' do
        login_as(user, scope: :user)
        visit '/en-US/frames/news/month'
        expect(page).to have_text("2020 March\n1")
        expect(page).to have_text("2020 April\n1")
        expect(page).to have_text("2020 May\n1")
      end
    end

    context 'when user in Hawaii (UTC -10:00)' do
      let(:profile) { create(:profile, time_zone: 'Hawaii') }
      let(:user) { create(:user, profile: profile) }

      it 'shows 3 items' do
        login_as(user, scope: :user)
        visit '/en-US/frames/news/month'
        expect(page).to have_text("2020 March\n1")
        expect(page).to have_text("2020 April\n1")
        expect(page).to have_text("2020 May\n1")
      end
    end

    context 'when requested another realm with another locale (ru locale)' do
      it 'shows 1 link from' do
        visit '/ru/frames/news/month'
        expect(page).to have_link(count: 1)
      end
    end
  end
end
