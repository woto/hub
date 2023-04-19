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

  context 'when requested domain matches with realm domain' do
    let!(:realm) { create(:realm, domain: 'crissy-moran.net') }

    it 'gets locale from `realm.locale`' do
      host! realm.domain
      expect(I18n).to receive(:with_locale).with(realm.locale).and_call_original
      get '/'
      expect(cookies[:locale]).to eq(realm.locale)
      expect(response.get_header('Content-Language')).to eq(realm.locale)
    end
  end

  context 'when locale in params' do
    it 'sets session ru locale' do
      expect(I18n).to receive(:with_locale).with('ru').and_call_original
      get '/ru'
      expect(cookies[:locale]).to eq('ru')
      expect(response.get_header('Content-Language')).to eq('ru')
    end

    it 'sets session en locale' do
      expect(I18n).to receive(:with_locale).with('en').and_call_original
      get '/en'
      expect(cookies[:locale]).to eq('en')
      expect(response.get_header('Content-Language')).to eq('en')
    end
  end

  context 'when locale in cookies' do
    it 'preserves ru session locale' do
      get '/ru'
      expect(cookies[:locale]).to eq('ru')
      expect(I18n).to receive(:with_locale).with('ru').and_call_original
      get '/'
      expect(cookies[:locale]).to eq('ru')
      expect(response.get_header('Content-Language')).to eq('ru')
    end

    it 'preserves en session locale' do
      get '/en'
      expect(cookies[:locale]).to eq('en')
      expect(I18n).to receive(:with_locale).with('en').and_call_original
      get '/'
      expect(cookies[:locale]).to eq('en')
      expect(response.get_header('Content-Language')).to eq('en')
    end
  end

  context 'when ru locale present in Accept-Language' do
    specify do
      expect(I18n).to receive(:with_locale).with('ru').and_call_original
      headers = { 'Accept-Language' => 'ru-RU, ru;q=0.9, en-US;q=1, en;q=0.7, fr;q=0.6' }
      get '/', headers: headers
      expect(response.get_header('Content-Language')).to eq('ru')
    end
  end

  context 'when en locale present in Accept-Language' do
    specify do
      expect(I18n).to receive(:with_locale).with('en').and_call_original
      headers = { 'Accept-Language' => 'en, ru;q=0.9, en-US;q=1, en;q=0.7, fr;q=0.6' }
      get '/', headers: headers
      expect(response.get_header('Content-Language')).to eq('en')
    end
  end

  context 'when only fr and de locales present in Accept-Language' do
    it 'sets default en locale' do
      expect(I18n).to receive(:with_locale).with('en').and_call_original
      headers = { 'Accept-Language' => 'fr-CH, fr;q=0.9, de;q=0.7, *;q=0.5' }
      get '/', headers: headers
      expect(response.get_header('Content-Language')).to eq('en')
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

  context 'when requests en locale' do
    specify do
      expect(I18n).to receive(:with_locale).with('en').and_call_original
      get '/en'
      expect(response.get_header('Content-Language')).to eq('en')
    end
  end

  context 'when requests ru locale' do
    specify do
      expect(I18n).to receive(:with_locale).with('ru').and_call_original
      get '/ru'
      expect(response.get_header('Content-Language')).to eq('ru')
    end
  end
end
