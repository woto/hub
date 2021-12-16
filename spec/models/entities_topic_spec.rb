# == Schema Information
#
# Table name: entities_topics
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  entity_id  :bigint           not null
#  topic_id   :bigint           not null
#
# Indexes
#
#  index_entities_topics_on_entity_id  (entity_id)
#  index_entities_topics_on_topic_id   (topic_id)
#
# Foreign Keys
#
#  fk_rails_...  (entity_id => entities.id)
#  fk_rails_...  (topic_id => topics.id)
#
require 'rails_helper'

RSpec.describe EntitiesTopic, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to(:entity).counter_cache(:topics_count) }
    it { is_expected.to belong_to(:topic).counter_cache(:entities_count) }
  end

  describe 'factory' do
    subject { build(:entities_topic) }

    it { is_expected.to be_valid }
  end

  context 'when removes entities_topic' do
    subject! { create(:entities_topic) }

    it 'does not entity and topic' do
      expect do
        expect do
          expect do
            subject.destroy
          end.to change(described_class, :count)
        end.not_to change(Entity, :count)
      end.not_to change(Topic, :count)
    end
  end
end
