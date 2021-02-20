# frozen_string_literal: true

require 'rails_helper'

describe Frames::News::LatestController do

describe '#index' do

  context 'when latest news are present' do
    let!(:news1) { create(:post, published_at: Time.zone.parse('2002-02-03 12:00')) }
    let!(:news2) { create(:post, published_at: Time.zone.parse('2001-02-03 12:00')) }

    before do
      visit frames_news_latest_path
    end

    it 'shows latest news intro' do
      within('turbo-frame#latest-news') do
        expect(page).to have_text(news1.intro.to_plain_text)
        expect(page).to have_link('Подробнее', href: news_path(news1, locale: 'ru'))
      end
    end

    it 'has link to previous news item' do
      within("div[data-test-id='link-to-older-news']") do
        expect(page).to(
            have_css("a[data-test-id='older-news'][href='/ru/frames/news/latest?page=1']")
        )
      end
    end

    it 'does not have link to next news item' do
      within("div[data-test-id='link-to-newer-news']") do
        expect(page).to(
            have_none_of_selectors('a')
        )
        expect(page).to(
            have_css("span[data-test-id='newer-news']")
        )
      end
    end

    context 'when user clicks on previous news link' do
      before do
        click_on('older-news')
      end

      it 'shows previous news intro' do
        within('turbo-frame#latest-news') do
          expect(page).to have_text(news2.intro.to_plain_text)
          expect(page).to have_link('Подробнее', href: news_path(news2, locale: 'ru'))
        end
      end

      it 'does not have link to previous news item' do
        within("div[data-test-id='link-to-older-news']") do
          expect(page).to(
              have_none_of_selectors('a')
          )
          expect(page).to(
              have_css("span[data-test-id='older-news']")
          )
        end
      end

      it 'has link to next news item' do
        within("div[data-test-id='link-to-newer-news']") do
          expect(page).to(
              have_css("a[data-test-id='newer-news'][href='/ru/frames/news/latest?page=0']")
          )
        end
      end
    end
  end

  context 'when latest news are absent' do
    before do
      visit frames_news_latest_path
    end

    it 'shows empty widget' do
      within('turbo-frame#latest-news') do
        expect(page).to have_text('Новости')
        expect(page).to have_text('Нет новостей')
        expect(page).to have_text('Новости на вашем языке пока что отсутствуют')
      end
    end
  end
end
end
