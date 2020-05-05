require 'rails_helper'

describe ArticlePage, type: :request do

  context 'when per greater than "MAX_PER"' do
    subject { get '/articles?per=10' }

    it 'returns "MAX_PER" count articles' do
      stub_const('ArticlePage::MAX_PER', 2)
      subject
      assert_select 'h2', count: 2
    end
  end

  context 'when per param empty' do
    subject { get '/articles' }

    it 'returns "DEFAULT_PER" count articles' do
      stub_const('ArticlePage::DEFAULT_PER', 2)
      subject
      assert_select 'h2', count: 2
    end
  end
end
