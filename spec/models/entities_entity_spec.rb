# frozen_string_literal: true

# == Schema Information
#
# Table name: entities_entities
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  child_id   :bigint           not null
#  parent_id  :bigint           not null
#
# Indexes
#
#  index_entities_entities_on_child_id   (child_id)
#  index_entities_entities_on_parent_id  (parent_id)
#
# Foreign Keys
#
#  fk_rails_...  (child_id => entities.id)
#  fk_rails_...  (parent_id => entities.id)
#
require 'rails_helper'

RSpec.describe EntitiesEntity, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to(:parent).inverse_of(:children_entities).class_name('Entity') }
    it { is_expected.to belong_to(:child).inverse_of(:parents_entities).class_name('Entity') }
  end

  describe 'factory' do
    subject { build(:entities_entity) }

    it { is_expected.to be_valid }

    specify do
      subject.save
      expect(subject.parent).to be_persisted
      expect(subject.child).to be_persisted
    end
  end

  context 'when removes entities_entity' do
    subject! { create(:entities_entity) }

    it 'does not remove parent and child' do
      expect do
        expect do
          subject.destroy
        end.to change(described_class, :count)
      end.not_to change(Entity, :count)
    end
  end
end
