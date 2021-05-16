# frozen_string_literal: true

require 'rails_helper'

describe Tables::HelpController, type: :system do
  describe 'GET /help' do
    it_behaves_like 'shared_language_component' do
      before do
        visit help_index_path
      end

      let(:link) { help_index_path(locale: 'en') }
    end
  end
end
