# frozen_string_literal: true

require 'rails_helper'

describe Extractors::YandexRu::MicrodataInteractor do
  context 'with url parameter' do
    it 'proxies request to yandex.com' do
      stub_request(:get, 'https://validator-api.semweb.yandex.ru/v1.1/url_parser?apikey=yandex_microdata_key_value&id=&lang=ru&only_errors=false&pretty=true&url=https://example.com')
        .to_return(status: 200, body: { a: 'b' }.to_json, headers: { 'Content-Type' => 'application/json' })
      result = described_class.call(url: 'https://example.com').object
      expect(result).to eq({ 'a' => 'b' })
    end
  end

  context 'with html parameter' do
    it 'proxies request to yandex.com' do
      stub_request(:post, "https://validator-api.semweb.yandex.ru/v1.1/document_parser?apikey=yandex_microdata_key_value&id=&lang=ru&only_errors=false&pretty=true")
        .with(body: '<html></html>')
        .to_return(status: 200, body: { a: 'b' }.to_json, headers: { 'Content-Type' => 'application/json' })

      result = described_class.call(html: '<html></html>').object
      expect(result).to eq({ 'a' => 'b' })
    end
  end
end
