# frozen_string_literal: true

require 'rails_helper'

describe ArticlesController, type: :request do
  before do
    stub_const('Article::ARTICLES_PATH',
               Rails.root.join('spec/fixtures/articles'))
  end

  it 'lists articles' do
    get '/articles'
    assert_select 'h1', count: 3
  end

  it 'shows article' do
    get '/articles/2020-01-24/some-cool-news'
    assert_select 'h1', count: 1
  end
end
