# frozen_string_literal: true

require 'rails_helper'

describe Tables::PostsController, type: :system do
  describe 'shared_workspace_authenticated' do
    it_behaves_like 'shared_workspace_authenticated' do
      let(:cols) { '0.6.5.16.13' }
      let(:plural) { 'posts' }
      let(:user) { create(:user, role: 'admin') }
    end
  end
end
