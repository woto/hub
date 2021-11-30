# == Schema Information
#
# Table name: lookups
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  entity_id  :bigint           not null
#
# Indexes
#
#  index_lookups_on_entity_id  (entity_id)
#
# Foreign Keys
#
#  fk_rails_...  (entity_id => entities.id)
#
require 'rails_helper'

RSpec.describe Lookup, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:entity).counter_cache(true) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe '#to_label' do
    subject { create(:entity, title: 'title') }

    specify do
      expect(subject.to_label).to eq('title')
    end
  end
end
