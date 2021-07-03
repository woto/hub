# frozen_string_literal: true

def create_post_categories_random_tree(realm)
  Array.new(20).map do
    parent = PostCategory.order('random()').find_by(realm: realm)
    PostCategory.create!(
      realm: realm,
      title: Faker::Lorem.sentence(word_count: 1, random_words_to_add: 4),
      parent: [nil, parent].sample
    )
  end
end

user = FactoryBot.create(:user, role: :admin)

I18n.available_locales.each do |locale|
  realm = Realm.pick(kind: :news, locale: locale)

  create_post_categories_random_tree(realm)
  post_categories = PostCategory.leaves.where(realm: realm).order('RANDOM()')

  20.times do
    Current.set(responsible: user) do
      post = FactoryBot.create(:post, realm: realm, user: user, post_category: post_categories.sample)
      post.update!(status: :accrued_post)
    end
  end
end
