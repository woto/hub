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
    tags = Faker::Lorem
           .sentences(number: rand(1..10))
           .map { |tag| tag.tr('.', '').split(' ') }
           .map { |arr| arr.sample(rand(1..3)).join(' ') }
           .select(&:present?)

    user = users.sample

    created_at = Faker::Date.between(from: 2.years.ago, to: 2.years.after)

    Current.set(responsible: user) do
      post = Post.create!(
        realm: news_realm,
        title: Faker::Lorem.sentence(word_count: 2, random_words_to_add: 12),
        intro: Faker::Lorem.paragraph(sentence_count: 1, random_sentences_to_add: 10),
        body: Faker::Lorem.paragraph(sentence_count: 1, random_sentences_to_add: 50),
        user: user,
        status: :draft,
        post_category: categories.sample,
        currency: :usd,
        tags: tags,
        published_at: created_at + rand(30).days,
        created_at: ExchangeRate.order('RANDOM()').first.date, #.to_time, # + rand(86_400).seconds - 1.second,
        updated_at: created_at
      )

      post.update!(status: :pending)
    end
  end
end
