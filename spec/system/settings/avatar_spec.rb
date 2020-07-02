# frozen_string_literal: true

require 'rails_helper'

describe Settings::AvatarsController, type: :system do
  before do
    login_as(user, scope: :user)
    visit '/settings/profile'
  end

  RSpec.shared_examples 'uploadable avatar' do |avatar_name|
    it 'uploads avatar' do
      page.attach_file(Rails.root.join('spec/fixtures/files', avatar_name)) do
        page.find('#avatar-clickable').click
      end

      within('#avatar-clickable') do
        expect(page).to have_css("img[src*='data:image']")
        expect(page).to have_css('.dz-success')
      end

      expect(user.reload.avatar.filename.to_s).to eq(avatar_name)
    end
  end

  context 'when avatar already uploaded' do
    let(:user) { create(:user) }

    it_behaves_like 'uploadable avatar', 'adriana_chechik.jpg'
  end

  context 'when avatar not uploaded yet' do
    let(:user) { create(:user, :with_avatar) }

    it_behaves_like 'uploadable avatar', 'jessa_rhodes.jpg'
  end
end
