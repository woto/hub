# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::ArticlesController, type: :request do
  let(:request!) { get '/api/v1/articles' }

  before do
    stub_const('Article::ARTICLES_PATH',
               Rails.root.join('spec/fixtures/articles/*'))
    request!
  end

  it 'responses successfully' do
    expect(response).to have_http_status(:ok)
  end

  it 'lists all articles' do
    expect(json_response_body).to match(
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
    expect(json_response_body['data'].first['attributes']).to match(
      'content' => a_value == "<h1 id=\"content\">Content</h1>\n",
      'preview' => a_value == "<h1 id=\"preview\">Preview</h1>\n",
      'created_at' => '2020-01-26'
    )
  end
end
