# frozen_string_literal: true

require 'rails_helper'

describe PostsController, type: :system, responsible: :user do
  let(:post) { create(:post, user: Current.responsible) }

  context 'with user' do
    it 'shows edit page' do
      login_as(Current.responsible, scope: :user)
      visit edit_post_path(post, locale: :ru)
      expect(page).to have_text('Редактирование статьи')
    end
  end

  context 'with another user' do
    it 'returns friendly error' do
      login_as(create(:user), scope: :user)
      visit post_path(post, locale: :ru)

      expect(page).to have_text("The page you were looking for doesn't exist")
    end
  end

  describe 'fills form inputs', responsible: :admin do
    before do
      login_as(Current.responsible, scope: :user)
      visit edit_post_path(post, locale: :ru)
    end

    it 'fills `Заголовок` correctly' do
      expect(page).to have_field('post[title]', with: post.title)
    end

    it 'fills `Статья` correctly' do
      expect(page).to have_field('post[body]', with: "<div>#{post.body.to_plain_text}</div>", type: :hidden)
    end

    it 'fills `Сайт` correctly' do
      expect(page).to have_select('post[realm_id]', visible: :hidden, selected: post.realm.to_label)
    end

    it 'fills `Категория` correctly' do
      expect(page).to have_select('post[post_category_id]', visible: :hidden, selected: post.post_category.to_label)
    end

    it 'fills `Теги` correctly' do
      expect(page).to have_select('post[tags][]', visible: :hidden, selected: post.tags)
    end

    it 'fills `Валюта` correctly' do
      expect(page).to have_select('post[currency]', selected: Money.from_amount(0, post.currency).currency.name)
    end

    it 'fills `Дата публикации` correctly' do
      find('#heading-post-item').click
      expect(page).to have_field('post[published_at]', with: post.published_at.strftime('%F %H:%M'))
    end

    it 'fills `Пользователь` correctly' do
      expect(page).to have_select('post[user_id]', visible: :hidden, selected: post.user.to_label)
    end

    it 'fills `Вступление` correctly' do
      expect(page).to have_field('post[intro]', with: "<div>#{post.intro.to_plain_text}</div>", type: :hidden)
    end

    it 'fills `Статус` correctly' do
      expect(page).to have_field('post[status]', with: post.status, checked: true)
    end
  end
end
