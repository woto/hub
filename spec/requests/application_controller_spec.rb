# frozen_string_literal: true

require 'rails_helper'

describe ApplicationController do
  describe 'locale' do
    context 'when subdomain' do
      it 'sets session locale' do
        host! 'ru.example.com'
        expect(I18n).to receive(:with_locale).with('ru', any_args)
        get '/'
        expect(session[:locale]).to eq('ru')
      end
    end

    context 'when locale in params' do
      it 'sets session locale' do
        expect(I18n).to receive(:with_locale).with('pt', any_args)
        get '/pt'
        expect(session[:locale]).to eq('pt')
      end
    end

    context 'when locale in session' do
      it 'preserves session locale' do
        get '/zh-CN'
        expect(session[:locale]).to eq('zh-CN')
        expect(I18n).to receive(:with_locale).with('zh-CN', any_args)
        get '/'
        expect(session[:locale]).to eq('zh-CN')
      end
    end

    context 'when locale is not available anywhere' do
      it 'uses default locale' do
        expect(I18n).to receive(:with_locale).with('en', any_args)
        get '/'
        expect(session[:locale]).to eq('en')
      end
    end

    describe 'Great Britain english locale' do
      specify do
        expect(I18n).to receive(:with_locale).with('en-GB', any_args)
        get '/en-GB'
      end
    end
  end
end
