# frozen_string_literal: true

require 'rails_helper'

describe Tables::PostsController, type: :system do
  let(:post) do
    create(:post,
           user: Current.responsible,
           created_at: 3.minutes.ago,
           updated_at: 2.minutes.ago,
           published_at: 1.minute.ago,
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

  it 'shows Post model attributes correctly' do
    login_as(Current.responsible, scope: :user)
    visit post_path(post, locale: :ru)

    # meta block
    expect(page).to have_text('Some post title')
    expect(page).to have_text(post.realm.to_label)
    expect(page).to have_text(post.post_category.title)
    expect(page).to have_text('Some post tag')
    expect(page).to have_text('3 минуты назад')
    expect(page).to have_text('несколько секунд назад')
    expect(page).to have_text('черновик')
    expect(page).to have_text('₽1,00')

    # extra options block
    expect(page).to have_field('Копирайт', checked: true, disabled: true)
    expect(page).to have_field('на сайте advego.ru', checked: true, disabled: true)
    expect(page).to have_text('Рерайт - пересказ общедоступного текста в интернете')

    # content block
    expect(page).to have_text('Body. Some long text')
  end

  context 'when visitor is admin' do
    it 'shows additional fields' do
      login_as(create(:user, role: :admin), scope: :user)
      visit post_path(post, locale: :ru)

      expect(page).to have_text('Intro. Post introduction')
      # published_at
      expect(page).to have_text('минуту назад')
    end
  end

  context 'when user does not own the post' do
    it 'returns friendly error' do
      login_as(create(:user), scope: :user)
      visit post_path(post, locale: :ru)

      expect(page).to have_text("The page you were looking for doesn't exist")
    end
  end
end
