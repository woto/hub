require 'rails_helper'

RSpec.describe PagesController, type: :request do
  describe "GET /show" do

    context 'when there is no such page' do
      it 'returns 404 page' do
        expect do
          get '/non-existent-page'
        end.to raise_error(ActionController::RoutingError)
      end
    end

    context 'when requests privacy policy page' do
      it 'shows it' do
        get '/privacy-policy'
        expect(response.body).to include('Настоящая политика обработки персональных данных')
      end
    end

    context 'when requests user agreement page' do
      it 'shows it correctly' do
        get '/user-agreement'
        expect(response.body).to include('вы принимаете и соглашаетесь соблюдать Правила')
      end
    end

  end
end
