# frozen_string_literal: true

require 'rails_helper'

describe 'Navbar favorites', type: :system do

  def favorite_link_text
    'Избранное'
  end

  context 'when user is not authenticated' do
    it 'does not show favorites link' do
      visit '/ru/offers'
      within 'header' do
        expect(page).not_to have_link(favorite_link_text)
      end
    end
  end

  context 'when user is authenticated' do
    subject do
      visit '/ru/offers'
      within 'header' do
        click_on favorite_link_text
      end
    end

    let(:user) { create(:user) }

    before do
      login_as(user, scope: :user)
    end

    context 'when user does not have any favorites lists' do
      it 'shows notice that user does not have any favorites lists' do
        subject
        expect(page).to have_text('Список избранного пока что пуст.')
      end
    end

    context 'when user has favorite list' do
      let!(:favorite) { create(:favorite, user: user) }

      it 'shows favorite list with correct link' do
        subject
        expect(page).to have_link(favorite.name, href: "/ru/#{favorite.kind}?favorite_id=#{favorite.id}")
      end
    end
  end
end
