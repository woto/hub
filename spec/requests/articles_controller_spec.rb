#

require 'rails_helper'

describe ArticlesController, type: :request do
  before do
    stub_const('Article::ARTICLES_PATH',
               Rails.root.join('spec/fixtures/articles'))
  end

  describe '#index' do
    subject! { get '/articles' }

    it 'has correct title' do
      assert_select 'h1', 'News'
    end

    it 'has correct number of news titles' do
      assert_select 'h2', count: 3
    end

    context 'when "per" param equals 1' do
      subject! { get '/articles?per=1' }

      it 'lists exactly the amount of news as "per" parameter' do
        assert_select 'h2', count: 1
      end
    end

    context 'when both "page" and "per" equals 1' do
      subject! { get '/articles?page=1&per=1' }

      it 'lists exactly the amount of articles as "per" parameter' do
        assert_select 'h2', count: 1
      end

      it 'lists correct news item' do
        assert_select 'h2', 'Another Good News'
      end

      it 'displays pagination' do
        assert_select '.pagination'
      end

      it 'markdownifies news preview' do
        assert_select '.news-preview:nth-child(2)', html: '<p>Preview text</p>'
      end
    end
  end

  describe '#show' do
    subject! { get '/articles/2020-01-26/another-good-news' }

    it 'has correct title' do
      assert_select 'h1', 'Another Good News'
    end

    it 'has correct content' do
      assert_select '.news-content', html: '<p>Content</p>'
    end

    it 'has correct publication date' do
      assert_select '.news-date', html: '2020-01-26'
    end
  end
end
