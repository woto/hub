# frozen_string_literal: true

require 'rails_helper'

describe PostsController, type: :system, responsible: :user do
  let(:post) do
    create(:post,
           user: Current.responsible,
           created_at: 3.hours.ago,
           # updated_at: 2.hours.ago,
           published_at: 1.hour.ago,
           tags: ['', 'Some post tag'],
           status: :draft_post,
           currency: :rub,
           title: 'Some post title',
           body: 'Body. Some long text',
           intro: 'Intro. Post introduction',
           extra_options: {
             post_type: 'copywrite',
             uniqueness_checked: ['', 'advego_ru']
           })
  end

  def article_check_link
    article_url(id: post.id, host: post.realm.domain, port: Capybara.current_session.server.port)
  end

  context 'with user' do
    it 'shows Post model attributes correctly' do
      login_as(Current.responsible, scope: :user)
      visit post_path(post, locale: :ru)

      within('main') do
        # meta block
        expect(page).to have_text('Some post title')
        expect(page).to have_text(post.realm.to_label)
        expect(page).to have_text(post.post_category.title)
        expect(page).to have_text('Some post tag')
        expect(page).to have_text('3 часа назад')
        expect(page).to have_text('несколько секунд назад')
        expect(page).to have_text('черновик')
        expect(page).to have_text('₽1,00')

        # extra options block
        expect(page).to have_field('Копирайт', checked: true, disabled: true)
        expect(page).to have_field('на сайте advego.ru', checked: true, disabled: true)
        expect(page).to have_text('Рерайт - пересказ общедоступного текста в интернете')

        # content block
        expect(page).to have_text('Body. Some long text')

        # visible to admin
        expect(page).to have_no_text('Intro. Post introduction')
        expect(page).to have_no_text(post.user.to_label)
        expect(page).to have_no_text('час назад')
        expect(page).to have_no_text(article_check_link)
      end
    end
  end

  context 'with another user' do
    it 'returns friendly error' do
      login_as(create(:user), scope: :user)
      visit post_path(post, locale: :ru)

      expect(page).to have_text("The page you were looking for doesn't exist")
    end
  end

  context 'with admin' do
    it 'shows additional fields' do
      login_as(create(:user, role: :admin), scope: :user)
      visit post_path(post, locale: :ru)

      within('main') do
        expect(page).to have_text('Intro. Post introduction')
        expect(page).to have_text(post.user.to_label)
        expect(page).to have_text('час назад')
        expect(page).to have_text(article_check_link)
      end
    end
  end
end
