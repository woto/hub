# frozen_string_literal: true

require 'rails_helper'

describe Tables::OffersController, type: :system do
  describe 'GET /offers' do
    it_behaves_like 'shared_language_component' do
      before do
        visit offers_path
      end

      let(:link) { offers_path(locale: 'en') }
    end
  end
end
