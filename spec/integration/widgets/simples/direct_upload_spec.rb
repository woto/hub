# frozen_string_literal: true

require 'rails_helper'

# NOTE: more tests with direct upload you can find in more complex tests living in create_spec.rb and update_spec.rb
describe Widgets::SimplesController, type: :system do
  let(:user) { create(:user) }
  let(:offer) { OfferCreator.call(feed_category: create(:feed_category)) }

  before do
    login_as(user, scope: :user)
    visit new_post_path(locale: :ru)

    within '.post_body' do
      click_on('Вставить виджет')
    end

    click_on('Создать новый виджет')
    click_link(href: '/ru/widgets/simples/new')
    expect(page).to have_text('Создание виджета')
  end

  context 'when file is chosen' do
    it 'uploads it' do
      expect do
        page.attach_file(file_fixture('jessa_rhodes.jpg')) do
          find('input[type="file"]').click
        end
        expect(page).to have_text('Файлы успешно загружены')
      end.to(change(ActiveStorage::Blob, :count))
    end
  end
end
