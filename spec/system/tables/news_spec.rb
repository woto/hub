# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'TODO Give a name! perfromance test on news' do

  before(:all) do
    elastic_client.indices.delete index: ::Elastic::IndexName.wildcard
    GlobalHelper.create_elastic_indexes
    elastic_client.indices.refresh
  end

  let_it_be(:exchange_rate) { create(:exchange_rate) }

  let_it_be(:news1) { create(:post, published_at: Time.zone.parse('2020-02-03 22:00')) }
  let_it_be(:news2) { create(:post, published_at: Time.zone.parse('2020-04-05 00:00')) }
  let_it_be(:news3) { create(:post, published_at: Time.zone.parse('2020-04-07 02:00'), tags: ['tag']) }
  let_it_be(:news4) { create(:post, published_at: Time.zone.parse('2020-04-07 02:01')) }

  let(:params) { {} }

  describe '#index' do

    context 'without follow_redirect!' do
      subject! do
        # login_as(user, scope: :user)
        visit news_index_path(params)
      end

      context 'when user does not have any workspace' do
        it 'redirects to system workspace' do
          expect(page).to have_current_path(news_index_path(order: :desc, per: 20, sort: :published_at, locale: :en))
        end
      end

      context 'when params partially present in request' do
        let(:params) { {per: 1} }
        it 'partially uses params in new location path' do
          expect(page).to have_current_path(news_index_path(order: :desc, per: 1, sort: :published_at, locale: :en))
        end
      end

      # TODO: Move out. It is not applicable for this controller
      #
      # context 'when user has default workspace' do
      #   before do
      #     user = FactoryBot.create(:user)
      #
      #     sign_in user
      #   end
      #   it 'redirects to user default workspace' do
      #     f
      #   end
      # end
    end

    context 'with follow_redirect!' do
      subject! do
        visit news_index_path(params)
        # get '/news', params: params
        # follow_redirect!
      end

      it 'has correct title' do
        expect(page).to have_css('h1', text: 'News')
      end

      it 'has correct number of news titles' do
        expect(page).to have_css('h2', count: 4)
      end

      context 'when "per" param equals 1' do
        let(:params) { {per: 1} }

        it 'lists exactly the amount of news as "per" parameter' do
          expect(page).to have_css('h2', count: 1)
        end
      end

      context 'when both "page" and "per" equals 1' do
        let(:params) { { page: 1, per: 1 } }

        it 'lists exactly the amount of articles as "per" parameter' do
          expect(page).to have_css('h2', count: 1)
        end

        it 'lists correct news item' do
          expect(page).to have_css('h2', text: news4.title)
        end

        it 'displays pagination' do
          expect(page).to have_css('.pagination')
        end

        it 'markdownifies news preview' do
          expect(page).to have_css('.news-preview:nth-child(2)', text: news4.intro.to_plain_text)
        end
      end

      describe 'news_by_month component' do
        pending
      end

      describe 'news_by_tag component' do
        pending
      end

      describe 'language_component' do
        it_behaves_like 'shared language_component' do
          let(:link) { news_index_path(locale: 'en') }
        end
      end
    end
  end

  describe '#by_tag' do
    context 'with follow_redirect!' do
      subject! do
        visit by_tag_news_index_path('tag')
      end

      describe 'language_component' do
        it_behaves_like 'shared language_component' do
          let(:link) { news_index_path(locale: 'en') }
        end
      end
    end
  end

  describe '#by_month' do
    context 'with follow_redirect!' do
      subject! do
        visit by_month_news_index_path('2020-04')
      end


      describe 'language_component' do
        it_behaves_like 'shared language_component' do
          let(:link) { news_index_path(locale: 'en') }
        end
      end
    end
  end
end
