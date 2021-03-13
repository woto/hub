# frozen_string_literal: true

# == Schema Information
#
# Table name: favorites
#
#  id                    :bigint           not null, primary key
#  favorites_items       :integer          default(0), not null
#  favorites_items_count :integer
#  is_default            :boolean          default(FALSE)
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
        favorite = create(:favorite, is_default: true, kind: :offers, name: 'Some name', user: user,
                                     favorites_items: create_list(:favorites_item, 2))

        expect(favorite.as_indexed_json).to match(
          id: favorite.id,
          favorites_items_count: 2,
          is_default: true,
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
