# frozen_string_literal: true

require 'rails_helper'

describe 'Frames::Articles::MonthController#index', type: :system, responsible: :admin do
  let(:future_time) { 1.minute.from_now }

  before do
    # news1
    create(:post, realm_kind: :news, realm_locale: 'en-US', published_at: Time.zone.parse('2020-03-31 22:00'),
                  status: :accrued_post)
    # news2
    create(:post, realm_kind: :news, realm_locale: 'en-US', published_at: Time.zone.parse('2020-04-01 02:00'),
                  status: :accrued_post)
    # news3
    create(:post, realm_kind: :news, realm_locale: 'en-US', published_at: Time.zone.parse('2020-05-10 12:00'),
                  status: :accrued_post)
    # news4 - Russian
    create(:post, realm_kind: :news, realm_locale: 'ru', published_at: 1.minute.ago, status: :accrued_post)
    # news5 - News from the feature
    create(:post, realm_kind: :news, realm_locale: 'en-US', published_at: future_time, status: :accrued_post)
  end

  it 'displays only news which matches the filter' do
    switch_realm(Realm.pick(locale: 'en-US', kind: :news)) do
      visit '/frames/articles/month?order=order&per=per&sort=sort'
    end

    expect(page).to have_link(count: 3)
    expect(page).to have_link('2020 March 1', href: '/month/2020-03?order=order&per=per&sort=sort')
    expect(page).to have_link('2020 April 1', href: '/month/2020-04?order=order&per=per&sort=sort')
    expect(page).to have_link('2020 May 1', href: '/month/2020-05?order=order&per=per&sort=sort')
  end

  context 'when time is in future' do
    it 'displays only news which matches the filter' do
      travel 2.minutes do
        switch_realm(Realm.pick(locale: 'en-US', kind: :news)) do
          visit 'frames/articles/month'
        end

        expect(page).to have_link(count: 4)
        expect(page).to have_link('2020 March 1', href: '/month/2020-03')
        expect(page).to have_link('2020 April 1', href: '/month/2020-04')
        expect(page).to have_link('2020 May 1', href: '/month/2020-05')
        I18n.with_locale(:en) do
          expect(page).to have_link("#{ApplicationController.helpers.l(future_time, format: '%Y %B')} 1")
        end
      end
    end
  end

  context 'when month is passed in params' do
    it 'highlights the tag' do
      switch_realm(Realm.pick(locale: 'en-US', kind: :news)) do
        visit 'frames/articles/month?month=2020-05&order=order&per=per&sort=sort'
      end
      expect(page).to have_css('.active', text: "2020 May\n1")
    end
  end

  context 'when user in Magadan (UTC +11:00)' do
    let(:profile) { create(:profile, time_zone: 'Magadan') }
    let(:user) { create(:user, profile: profile) }

    it 'shows 3 items' do
      login_as(user, scope: :user)
      switch_realm(Realm.pick(locale: 'en-US', kind: :news)) do
        visit '/frames/articles/month'
      end
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
      switch_realm(Realm.pick(locale: 'en-US', kind: :news)) do
        visit '/frames/articles/month'
      end
      expect(page).to have_text("2020 March\n1")
      expect(page).to have_text("2020 April\n1")
      expect(page).to have_text("2020 May\n1")
    end
  end

  context 'when requested realm with ru local' do
    it 'shows 1 link from' do
      switch_realm(Realm.pick(locale: 'ru', kind: :news)) do
        visit 'frames/articles/month'
      end
      expect(page).to have_link(count: 1)
    end
  end
end
