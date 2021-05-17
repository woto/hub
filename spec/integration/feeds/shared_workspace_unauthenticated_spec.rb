# frozen_string_literal: true

require 'rails_helper'

describe Tables::FeedsController, type: :system do
  describe 'GET /feeds' do
    it_behaves_like 'shared_workspace_unauthenticated' do
      before do
        create(:feed)
        visit '/ru/feeds'
      end
    end
  end
end
