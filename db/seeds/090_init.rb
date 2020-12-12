# frozen_string_literal: true

I18n.available_locales.each do |locale|
  rand(1..3).times.each do
    Realm.create!(
      title: Faker::Lorem.sentence(word_count: 1, random_words_to_add: 4),
      locale: locale,
      kind: :website
    )
  end
end
