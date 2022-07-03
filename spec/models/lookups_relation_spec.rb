# == Schema Information
#
# Table name: lookups_relations
#
#  id            :bigint           not null, primary key
#  relation_type :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  lookup_id     :bigint           not null
#  relation_id   :bigint           not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_lookups_relations_on_lookup_id  (lookup_id)
#  index_lookups_relations_on_relation   (relation_type,relation_id)
#  index_lookups_relations_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (lookup_id => lookups.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe LookupsRelation, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user).optional }
    it { is_expected.to belong_to(:lookup) }
    it { is_expected.to belong_to(:relation) }
  end

  describe 'validations' do
    let(:entity) { create(:entity) }
    let(:lookup) { create(:lookup) }

    def create_lookups_relation
      LookupsRelation.create(lookup: lookup, relation: entity)
    end

    it 'does not allow to link same `lookup` and `relation` twice' do
      expect do
        2.times { create_lookups_relation }
      end.to change(LookupsRelation, :count).from(0).to(1)
    end
  end    
end
