# frozen_string_literal: true

# == Schema Information
#
# Table name: favorites
#
#  id                    :bigint           not null, primary key
#  favorites_items       :integer          default(0), not null
#  favorites_items_count :integer
#  kind                  :integer          not null
#  name                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  user_id               :bigint           not null
#
# Indexes
#
#  index_favorites_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

describe Favorite, type: :model do
  it_behaves_like 'elasticable'

  it {
    expect(subject).to define_enum_for(:kind).with_values(
      %i[users posts transactions accounts checks feeds post_categories offers]
    )
  }

  it { is_expected.to belong_to(:user).counter_cache(true).touch(true) }
  it { is_expected.to have_many(:favorites_items).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:kind) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(30) }

  describe '#to_label' do
    subject { create(:favorite, name: 'Favorite') }

    specify do
      expect(subject.to_label).to eq('Favorite')
    end
  end

  describe '#as_indexed_json' do
    it 'returns expected structure' do
      freeze_time do
        user = create(:user)
        favorite = create(
          :favorite,
          kind: :offers,
          name: 'Some name',
          user: user,
          favorites_items: build_list(
            :favorites_item, 2, kind: %i[advertiser_id feed_id feed_category_id _id].sample
          )
        )

        expect(favorite.as_indexed_json).to match(
          id: favorite.id,
          favorites_items_count: 2,
          kind: 'offers',
          name: 'Some name',
          created_at: Time.current,
          updated_at: Time.current,
          user_id: user.id
        )
      end
    end
  end
end
