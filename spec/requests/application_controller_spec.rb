# frozen_string_literal: true

require 'rails_helper'

describe ApplicationController do
  describe 'locale' do
    context 'when subdomain' do
      it 'sets session locale' do
        host! 'ru.example.com'
        expect(I18n).to receive(:with_locale).with('ru').and_call_original
        get '/'
        expect(cookies[:locale]).to eq('ru')
      end
    end

    context 'when locale in params' do
      it 'sets session locale' do
        expect(I18n).to receive(:with_locale).with('pt').and_call_original
        get '/pt'
        expect(cookies[:locale]).to eq('pt')
      end
    end

    context 'when locale in session' do
      it 'preserves session locale' do
        get '/zh-CN'
        expect(cookies[:locale]).to eq('zh-CN')
        expect(I18n).to receive(:with_locale).with('zh-CN').and_call_original
        get '/'
        expect(cookies[:locale]).to eq('zh-CN')
      end
    end

    context 'when locale is not available anywhere' do
      it 'uses default locale' do
        expect(I18n).to receive(:with_locale).with('en').and_call_original
        get '/'
        expect(cookies[:locale]).to eq('en')
      end
    end

    describe 'Great Britain english locale' do
      specify do
        expect(I18n).to receive(:with_locale).with('en-GB').and_call_original
        get '/en-GB'
      end
    end
  end
end
