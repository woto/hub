# frozen_string_literal: true

require 'rails_helper'

describe 'Table Header', type: :system do
  describe 'long' do
    context 'when form sends with incorrect values' do
      before do
        visit feeds_path({ q: 'a', per: 5, page: 10, sort: 'id', order: 'asc', columns: %w[id],
                           trash: 'trash', locale: 'ru' })
      end

      it 'shows errors' do
        click_on('ID')
        click_on('Применить фильтр')

        within('#new_filter_form') do
          expect(page).to have_css('#filter_form_min ~ .invalid-feedback',
                                   text: 'Минимальное значение не может быть пустым')
          expect(page).to have_css('#filter_form_max ~ .invalid-feedback',
                                   text: 'Максимальное значение не может быть пустым')
        end
      end
    end

    context 'when url contains filters and clicks on filter link' do
      before do
        visit feeds_path({ q: 'a', per: 5, page: 10, sort: 'id', order: 'asc', columns: %w[id],
                           filters: { id: { max: 10, min: 1 } }, trash: 'trash', locale: 'ru' })
      end

      it 'opens form with prefilled values' do
        click_on('ID')

        within('#new_filter_form') do
          expect(page).to have_field('Минимальное значение', with: 1)
          expect(page).to have_field('Максимальное значение', with: 10)
        end
      end
    end

    context 'when form has errors and then fixed them resending form' do
      before do
        visit feeds_path({ q: 'a', per: 5, page: 10, sort: 'id', order: 'asc', columns: %w[id],
                           trash: 'trash', locale: 'ru' })
      end

      it 'redirects to correct url' do
        click_on('ID')
        click_on('Применить фильтр')

        within('#new_filter_form') do
          expect(page).to have_text 'Минимальное значение не может быть пустым'
          expect(page).to have_text 'Максимальное значение не может быть пустым'

          fill_in('Минимальное значение', with: 2)
          fill_in('Максимальное значение', with: 3)
          click_on('Применить фильтр')
        end

        expect(page).to have_current_path(
          feeds_path({ q: 'a', per: 5, page: 10, sort: 'id', order: 'asc', columns: %w[id],
                       filters: { id: { max: 3, min: 2 } }, locale: 'ru' })
        )
      end
    end

    context 'when form sends with correct values' do
      before do
        visit feeds_path({ q: 'a', per: 5, page: 10, sort: 'id', order: 'asc', columns: %w[id],
                           trash: 'trash', locale: 'ru' })
      end

      it 'redirects to correct url' do
        click_on('ID')

        within('#new_filter_form') do
          fill_in('Минимальное значение', with: 2)
          fill_in('Максимальное значение', with: 3)
          click_on('Применить фильтр')
        end

        expect(page).to have_current_path(
          feeds_path({ q: 'a', per: 5, page: 10, sort: 'id', order: 'asc', columns: %w[id],
                       filters: { id: { max: 3, min: 2 } }, locale: 'ru' })
        )
      end
    end
  end

  describe 'reset filters' do
    context 'when filters are not set and clicks on reset filter' do
      before do
        visit feeds_path({ q: 'a', per: 5, page: 10, sort: 'id', order: 'asc', columns: %w[id],
                           trash: 'trash', locale: 'ru' })
      end

      it 'redirects correctly' do
        click_on('ID')
        click_on('Сбросить фильтр')

        expect(page).to have_current_path(
          feeds_path(q: 'a', per: 5, page: 10, sort: 'id', order: 'asc', columns: %w[id], locale: 'ru')
        )
      end
    end

    context 'when filters are set on two columns and clicks on reset filter' do
      before do
        visit feeds_path(q: 'a', per: 5, page: 10, sort: 'id', order: 'asc', columns: %w[id advertiser_name],
                         filters: { id: { max: 10, min: 1 }, advertiser_name: { value: 'test' } }, trash: 'trash',
                         locale: 'ru')
      end

      it 'redirects correctly' do
        click_on('ID')
        click_on('Сбросить фильтр')

        expect(page).to have_current_path(
          feeds_path(q: 'a', per: 5, page: 10, sort: 'id', order: 'asc', columns: %w[id advertiser_name],
                     filters: { advertiser_name: { value: 'test' } }, locale: 'ru')
        )
      end
    end
  end
end
