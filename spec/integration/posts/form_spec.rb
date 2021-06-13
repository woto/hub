# frozen_string_literal: true

require 'rails_helper'

describe PostsController, type: :system, responsible: :admin do
  let(:post) { create(:post, user: Current.responsible) }

  describe 'shows admin form errors correctly' do
    before do
      login_as(Current.responsible, scope: :user)
      visit new_post_path(locale: :ru)

    end

    it 'shows errors' do
      click_on('Создать Post')

      expect(page).to have_text('Title не может быть пустым')
      expect(page).to have_text('Body недостаточной длины (не может быть меньше 1 символа)')
      expect(page).to have_text('Realm не может отсутствовать')
      expect(page).to have_text('Post category не может отсутствовать')
      expect(page).to have_text('Tags недостаточной длины (не может быть меньше 2 символов)')
      expect(page).to have_text('Currency имеет непредусмотренное значение')
      expect(page).to have_text('Status не может быть пустым')
    end

    context 'when status is `accrued`' do
      it 'shows errors inherent in this status' do
        choose 'зачислено'

        click_on('Создать Post')

        expect(page).to have_text('Published at не может быть пустым')
        # expect(page).to have_text('User не может отсутствовать')
        expect(page).to have_text('Intro недостаточной длины (не может быть меньше 1 символа)')
      end
    end
  end
end
