# frozen_string_literal: true

require 'rails_helper'

describe Tables::FeedsController, type: :system do
  before do
    login_as(user, scope: :user)
    visit feeds_path({ q: 'a', per: 5, page: 10, sort: 'id', order: 'asc', columns: %w[id name],
                       filters: { id: { max: 10, min: 1 } }, trash: 'trash', locale: 'ru' })
  end

  let(:user) { create(:user) }

  context 'when page loads' do
    it 'has correct model field value' do
      expect(page).to have_field('workspace_form[model]', with: 'feeds', type: :hidden)
    end

    it 'has correct state field value' do
      params = { 'q' => 'a', 'per' => '5', 'page' => '10', 'sort' => 'id', 'order' => 'asc',
                 'filters' => { 'id' => { 'min' => '1', 'max' => '10' } }, 'columns' => %w[id name] }

      field = page.find_field('workspace_form[state]', type: :hidden)
      expect(JSON.parse(field.value)).to eq(params)
    end
  end

  context "when sent form's data is not correct" do
    before do
      click_on('Области')

      expect(page).not_to have_text('не может быть пустым')
      click_on('Сохранить')
      expect(page).to have_text('не может быть пустым')
    end

    it 'preserves correct modal field value' do
      expect(page).to have_field('workspace_form[model]', with: 'feeds', type: :hidden)
    end

    it 'preserves correct state field value' do
      params = { 'q' => 'a', 'per' => '5', 'page' => '10', 'sort' => 'id', 'order' => 'asc',
                 'filters' => { 'id' => { 'min' => '1', 'max' => '10' } }, 'columns' => %w[id name] }

      field = page.find_field('workspace_form[state]', type: :hidden)
      expect(JSON.parse(field.value)).to eq(params)
    end
  end

  context "when sent form's data is correct" do
    let(:name) { Faker::Alphanumeric.alphanumeric }

    it 'saves workspace and redirects to correct page' do
      click_on('Области')

      fill_in 'Введите имя', with: name

      expect do
        click_on 'Сохранить'

        expect(page).to have_text(name)
        expect(page).to(
          have_current_path(
            feeds_path({ q: 'a', per: 5, page: 10, sort: 'id', order: 'asc', columns: %w[id name],
                         filters: { id: { max: 10, min: 1 } }, locale: 'ru' })
          )
        )
      end.to change(user.workspaces, :count)
    end
  end
end
