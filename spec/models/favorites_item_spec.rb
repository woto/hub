# frozen_string_literal: true

# == Schema Information
#
# Table name: favorites_items
#
#  id          :bigint           not null, primary key
#  kind        :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  ext_id      :string           not null
#  favorite_id :bigint           not null
#
# Indexes
#
#  index_favorites_items_on_favorite_id  (favorite_id)
#
# Foreign Keys
#
#  fk_rails_...  (favorite_id => favorites.id)
#
require 'rails_helper'

describe FavoritesItem, type: :model do
  subject { create(:favorites_item, favorite: favorite, kind: :_id) }

  let(:favorite) { create(:favorite, kind: :offers) }

  it { is_expected.to belong_to(:favorite).counter_cache(true) }
  it { is_expected.to validate_presence_of(:kind) }
  it { is_expected.to validate_presence_of(:ext_id) }

  it {
    expect(subject).to define_enum_for(:kind).with_values(
      %i[users posts transactions accounts checks feeds post_categories advertiser_id feed_id feed_category_id _id realms]
    )
  }

  shared_examples_for 'valid kinds' do |favorites_item_kind, favorite_kind|
    subject { build(:favorites_item, kind: favorites_item_kind, favorite: create(:favorite, kind: favorite_kind)) }

    it { is_expected.to be_valid }
  end

  shared_examples_for 'invalid kinds' do |favorites_item_kind, favorite_kind|
    subject { build(:favorites_item, kind: favorites_item_kind, favorite: create(:favorite, kind: favorite_kind)) }

    it { is_expected.not_to be_valid }
  end


  it_behaves_like 'valid kinds', 'accounts', 'accounts'
  it_behaves_like 'valid kinds', 'feeds', 'feeds'
  it_behaves_like 'valid kinds', 'posts', 'posts'
  it_behaves_like 'valid kinds', 'transactions', 'transactions'
  it_behaves_like 'valid kinds', 'checks', 'checks'
  it_behaves_like 'valid kinds', 'post_categories', 'post_categories'
  it_behaves_like 'valid kinds', 'advertiser_id', 'offers'
  it_behaves_like 'valid kinds', 'feed_id', 'offers'
  it_behaves_like 'valid kinds', 'feed_category_id', 'offers'
  it_behaves_like 'valid kinds', '_id', 'offers'

  it_behaves_like 'invalid kinds', 'accounts', 'feeds'
  it_behaves_like 'invalid kinds', '_id', 'accounts'
  it_behaves_like 'invalid kinds', 'transactions', 'offers'
end
