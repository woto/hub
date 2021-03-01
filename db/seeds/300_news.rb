# frozen_string_literal: true

users = []
rand(1..2).times do |_i|
  users << FactoryBot.create(:user)
end

I18n.available_locales.each do |locale|
  news_realm = Realm.create!(title: 'Новости', locale: locale, kind: 'news')

  payments = PostCategory.create!(realm: news_realm, title: 'Выплаты')
  maintenance = PostCategory.create!(realm: news_realm, title: 'Регламентные работы')
  advertisers = PostCategory.create!(realm: news_realm, title: 'Рекламодателям')
  webmasters =  PostCategory.create!(realm: news_realm, title: 'Вебмастерам')

  categories = [payments, advertisers, maintenance, webmasters]

  rand(20..40).times do

    user = users.sample

    Current.set(responsible: user) do
      post = FactoryBot.create(:post, realm: news_realm, user: user, post_category: categories.sample)
      post.update!(status: :pending)
    end
  end
end
