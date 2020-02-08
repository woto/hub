# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::ArticlesController, type: :request do
  before do
    stub_const('Article::ARTICLES_PATH',
               Rails.root.join('spec/fixtures/articles'))
    stub_const('ArticlePage::MAX_PER', max_per) if defined?(max_per)
    stub_const('ArticlePage::DEFAULT_PER', default_per) if defined?(default_per)
    request!
  end

  describe '#index' do
    let(:request!) { get '/api/v1/articles' }

    it 'responses successfully' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns correct number of articles' do
      expect(json_response_body['data'].count).to eq 3
    end

    it 'returns correct totalCount' do
      expect(json_response_body).to include(
        'data' => be_an_instance_of(Array),
        'meta' => { 'totalCount' => a_value == 3 }
      )
    end

    context 'when per param equals 1' do
      let(:request!) { get '/api/v1/articles?per=1' }

      it "lists exactly same articles as 'per' parameter" do
        expect(json_response_body['data'].length).to be(1)
      end
    end

    context 'when both page and per equals 1' do
      let(:request!) { get '/api/v1/articles?page=1&per=1' }

      it "lists exactly same articles as 'per' parameter" do
        expect(json_response_body['data'].length).to be(1)
      end
    end

    it 'markdownify article' do
      expect(json_response_body['data'].first['attributes']).to match(serialized_article)
    end

    describe ArticlePage do
      context 'when per greater than MAX_PER' do
        let(:request!) { get '/api/v1/articles?per=10' }
        let(:max_per) { 2 }

        it "returns MAX_PER count articles" do
          expect(json_response_body['data'].length).to be(2)
        end
      end

      context 'when per param empty' do
        let(:default_per) { 2 }

        it "returns DEFAULT_PER count articles" do
          expect(json_response_body['data'].length).to be(2)
        end
      end
    end
  end

  describe '#show' do
    let(:request!) { get '/api/v1/articles/2020-01-26/another-good-news' }

    it 'gets article' do
      expect(json_response_body['data']).to match(
        'id' => '2020-01-26/another-good-news',
        'type' => 'article',
        'attributes' => serialized_article
      )
    end
  end

  private

  def serialized_article
    { 'content' => a_value == "<div class='ant-typography'><h1 class='ant-typography'>Content</h1></div>",
      'preview' => a_value == "<div class='ant-typography'><h1 class='ant-typography'>Preview</h1></div>",
      'meta' => {
        'date' => '2020-01-24',
        'title' => 'Another Good News'
      } }
  end
end
