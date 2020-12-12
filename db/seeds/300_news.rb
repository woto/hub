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

  rand(1..2).times do
    tags = Faker::Lorem
           .sentences(number: rand(1..10))
           .map { |tag| tag.tr('.', '').split(' ') }
           .map { |arr| arr.sample(rand(1..3)).join(' ') }
           .select(&:present?)

    user = users.sample

    Current.set(responsible: user) do
      post = Post.create(
        realm: news_realm,
        title: Faker::Lorem.sentence(word_count: 2, random_words_to_add: 12),
        intro: Faker::Lorem.paragraph(sentence_count: 1, random_sentences_to_add: 10),
        body: Faker::Lorem.paragraph(sentence_count: 1, random_sentences_to_add: 50),
        user: user,
        status: :draft,
        post_category: categories.sample,
        currency: :usd,
        published_at: Time.current,
        tags: tags
      )

      debugger unless post.persisted?

      post.update!(status: :pending)
    end
  end
end
