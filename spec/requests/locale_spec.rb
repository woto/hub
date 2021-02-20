# frozen_string_literal: true

require 'rails_helper'

describe Locale do
  context 'when subdomain' do
    it 'stores locale in cookies' do
      host! 'ru.example.com'
      expect(I18n).to receive(:with_locale).with('ru').and_call_original
      get '/'
      expect(cookies[:locale]).to eq('ru')
      expect(response.get_header('Content-Language')).to eq('ru')
    end
  end

  context 'when locale in params' do
    it 'sets session locale' do
      expect(I18n).to receive(:with_locale).with('pt').and_call_original
      get '/pt'
      expect(cookies[:locale]).to eq('pt')
      expect(response.get_header('Content-Language')).to eq('pt')
    end
  end

  context 'when locale in cookies' do
    it 'preserves session locale' do
      get '/zh-CN'
      expect(cookies[:locale]).to eq('zh-CN')
      expect(I18n).to receive(:with_locale).with('zh-CN').and_call_original
      get '/'
      expect(cookies[:locale]).to eq('zh-CN')
      expect(response.get_header('Content-Language')).to eq('zh-CN')
    end
  end

  context 'when locale present in Accept-Language' do
    specify do
      expect(I18n).to receive(:with_locale).with('ru').and_call_original
      headers = { 'Accept-Language' => 'ru-RU, ru;q=0.9, en-US;q=0.8, en;q=0.7, fr;q=0.6' }
      get '/', headers: headers
      expect(response.get_header('Content-Language')).to eq('ru')
    end
  end

  context 'when locale is not available anywhere' do
    it 'uses default locale' do
      expect(I18n).to receive(:with_locale).with('en').and_call_original
      get '/'
      expect(cookies[:locale]).to eq('en')
      expect(response.get_header('Content-Language')).to eq('en')
    end
  end

  context 'when requests en-GB locale (differs from en)' do
    specify do
      expect(I18n).to receive(:with_locale).with('en-GB').and_call_original
      get '/en-GB'
      expect(response.get_header('Content-Language')).to eq('en-GB')
    end
  end
end
