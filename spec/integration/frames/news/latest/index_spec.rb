# frozen_string_literal: true

require 'rails_helper'

describe 'Frames::Articles::LatestController#index', type: :system, responsible: :admin do
  context 'when latest news are present' do
    let!(:article1) do
      create(:post, realm_kind: :news, realm_locale: :ru, published_at: Time.zone.parse('2002-02-03 12:00'),
                    status: :accrued_post)
    end
    let!(:article2) do
      create(:post, realm_kind: :news, realm_locale: :ru, published_at: Time.zone.parse('2001-02-03 12:00'),
                    status: :accrued_post)
    end

    before do
      visit frames_articles_latest_path(locale: 'ru')
    end

    it 'shows latest news intro' do
      within('turbo-frame#articles-latest') do
        expect(page).to have_text(article1.intro.to_plain_text)
        expect(page).to have_link('Подробнее...', href: article_url(
          article1,
          host: article1.realm.domain,
          port: Capybara.current_session.server.port
        ))
      end
    end

    it 'has link to older article' do
      within("div[data-test-id='link-to-older-article']") do
        expect(page).to(
          have_css("a[data-test-id='older-article'][href='/ru/frames/articles/latest?page=1']")
        )
      end
    end

    it 'does not have link to newer article' do
      within("div[data-test-id='link-to-newer-article']") do
        expect(page).to(
          have_none_of_selectors('a')
        )
        expect(page).to(
          have_css("span[data-test-id='newer-article']")
        )
      end
    end

    context 'when user clicks on previous news link' do
      before do
        click_on('older-article')
      end

      it 'shows older article intro' do
        within('turbo-frame#articles-latest') do
          expect(page).to have_text(article2.intro.to_plain_text)
          expect(page).to have_link('Подробнее...', href: article_url(
            article2,
            host: article1.realm.domain,
            port: Capybara.current_session.server.port
          ))
        end
      end

      it 'does not have link to previous news item' do
        within("div[data-test-id='link-to-older-article']") do
          expect(page).to(
            have_none_of_selectors('a')
          )
          expect(page).to(
            have_css("span[data-test-id='older-article']")
          )
        end
      end

      it 'has link to next news item' do
        within("div[data-test-id='link-to-newer-article']") do
          expect(page).to(
            have_css("a[data-test-id='newer-article'][href='/ru/frames/articles/latest?page=0']")
          )
        end
      end
    end
  end

  context 'when latest article is absent' do
    before do
      visit frames_articles_latest_path(locale: 'ru')
    end

    it 'shows empty widget' do
      within('turbo-frame#articles-latest') do
        expect(page).to have_text('Новости')
        expect(page).to have_text('Нет новостей')
        expect(page).to have_text('Новости на вашем языке пока что отсутствуют')
      end
    end
  end
end
