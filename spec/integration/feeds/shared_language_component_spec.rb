# frozen_string_literal: true

require 'rails_helper'

describe Tables::FeedsController, type: :system do
  describe 'GET /feeds' do
    it_behaves_like 'shared_language_component' do
      before do
        visit feeds_path
      end

      let(:link) { feeds_path(locale: 'en') }
    end
  end
end
