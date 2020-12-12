# frozen_string_literal: true

def create_post_categories_random_tree
  rand(1..100).times do |_i|
    realm = Realm.website.order('random()').first
    parent = PostCategory.where(realm: realm).order('random()').first
    PostCategory.create!(
      realm: realm,
      title: Faker::Lorem.sentence(word_count: 1, random_words_to_add: 4),
      parent: [nil, parent].sample
    )
  end
end

create_post_categories_random_tree
