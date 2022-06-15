# frozen_string_literal: true

require 'rails_helper'

shared_examples 'shared favorites listing only favorites' do
  it 'works', focus: true do
    favorite = create(:favorite, user: Current.responsible, kind: favorite_kind)
    favorites_item = create(:favorites_item, ext_id: ext_id, kind: favorites_item_kind, favorite: favorite)

    other_favorite = create(:favorite, user: Current.responsible, kind: favorite_kind)

    login_as(Current.responsible, scope: :user)
    visit polymorphic_path([favorite_kind], favorite_id: favorite.id)
    expect(page).to have_button("favorite-#{favorites_item.kind}-#{favorites_item.ext_id}")

    visit polymorphic_path([favorite_kind], favorite_id: other_favorite.id)
    expect(page).not_to have_button("favorite-#{favorites_item.kind}-#{favorites_item.ext_id}")
  end
end

shared_examples 'shared favorites removing favorites_item from exiting favorite' do
  it 'removes favorites_item from exiting favorite' do
    favorite = create(:favorite, user: Current.responsible, kind: favorite_kind)
    favorites_item = create(:favorites_item, ext_id: ext_id, kind: favorites_item_kind, favorite: favorite)

    login_as(Current.responsible, scope: :user)
    visit visit_path

    within('section.page') do
      button = find_button("favorite-#{favorites_item.kind}-#{favorites_item.ext_id}")
      expect(button).to match_css('.active')
      button.ancestor('.z-index-decreased')

      button.click

      expect(button).to match_css('.active.show')
      button.ancestor('.z-index-increased')

      expect(page).to have_text("#{favorite.name}\n1")

      label = find("[data-star-favorite-item-name-value='#{favorite.name}'][data-star-favorite-item-ext-id-value='#{favorites_item.ext_id}']")

      within(label) do
        checkbox = find('input')
        expect(checkbox).to be_checked
      end

      label.click

      expect(button).not_to match_css('.active')
      expect(button).not_to match_css('.show')
      button.ancestor('.z-index-decreased')
    end

    expect(page).to have_text 'Успешно удалено из избранного'
  end
end

shared_examples 'shared favorites adding favorites_item to exiting favorite' do
  it 'adds new favorites_item to exiting favorite' do
    favorite = create(:favorite, user: Current.responsible, kind: favorite_kind)
    favorites_item = build(:favorites_item, ext_id: ext_id, kind: favorites_item_kind, favorite: favorite)

    login_as(Current.responsible, scope: :user)
    visit visit_path

    within('section.page') do
      button = find_button("favorite-#{favorites_item.kind}-#{favorites_item.ext_id}")
      expect(button).to not_match_css('.active')
      expect(button).to not_match_css('.show')

      button.click

      expect(button).to not_match_css('.active')
      expect(button).to match_css('.show')

      expect(page).to have_text("#{favorite.name}\n0")
      label = find([
        "[data-star-favorite-item-name-value='#{favorite.name}']",
        "[data-star-favorite-item-ext-id-value='#{favorites_item.ext_id}']"
      ].join)

      within(label) do
        checkbox = find('input')
        expect(checkbox).not_to be_checked
      end

      label.click

      expect(button).to match_css('.active')
      expect(button).not_to match_css('.show')
      button.ancestor('.z-index-decreased')
    end

    expect(page).to have_text 'Успешно добавлено в избранное'
  end
end

shared_examples 'shared favorites adding favorites_item to new favorite' do
  it 'adds new favorites_item to new favorite' do
    favorite = build(:favorite, user: Current.responsible, kind: favorite_kind)
    favorites_item = build(:favorites_item, ext_id: ext_id, kind: favorites_item_kind)

    login_as(Current.responsible, scope: :user)
    visit visit_path

    within('section.page') do
      button = find_button("favorite-#{favorites_item.kind}-#{favorites_item.ext_id}")
      expect(button).to not_match_css('.active')
      expect(button).to not_match_css('.show')

      button.click

      expect(button).to not_match_css('.active')
      expect(button).to match_css('.show')
      button.ancestor('.z-index-increased')

      fill_in('Введите название...', with: favorite.name)

      create_button = find('[data-action="star-favorite#createFavorite"]')
      create_button.click

      expect(button).to match_css('.active')
      expect(button).to not_match_css('.show')
      button.ancestor('.z-index-decreased')
    end

    expect(page).to have_text 'Успешно добавлено в избранное'
  end
end
