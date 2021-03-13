# frozen_string_literal: true

require 'rails_helper'

describe FavoritesStore do
  it 'finds only specific favorites' do
    favorites_item = create(:favorites_item)
    favorites_store = described_class.new(favorites_item.favorite.user,
                                          favorites_item.ext_id,
                                          favorites_item.favorite.kind,
                                          favorites_item.kind)

    expect(favorites_store.find(favorites_item.ext_id)).to be_truthy
    expect(favorites_store.find(Faker::Alphanumeric.alphanumeric)).to be_falsey
  end

  it 'issues correct SQL' do
    user_id = Faker::Number.number(digits: 5)
    favorites_item = build(:favorites_item)
    favorites_store = described_class.new(user_id,
                                          favorites_item.ext_id,
                                          favorites_item.favorite.kind,
                                          favorites_item.kind)
    sql = %(
      SELECT DISTINCT ON (ext_id) ext_id
      FROM "favorites_items"
      INNER JOIN "favorites" ON "favorites"."id" = "favorites_items"."favorite_id"
      WHERE "favorites"."user_id" = #{user_id}
        AND "favorites"."kind" = #{Favorite.kinds[favorites_item.favorite.kind]}
        AND "favorites_items"."kind" = #{FavoritesItem.kinds[favorites_item.kind]}
        AND "favorites_items"."ext_id" = '#{favorites_item.ext_id}'
      ).squish

    expect(favorites_store.items.to_sql).to(eq(sql))
  end
end
