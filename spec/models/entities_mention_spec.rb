# frozen_string_literal: true

# == Schema Information
#
# Table name: entities_mentions
#
#  id           :bigint           not null, primary key
#  mention_date :datetime
#  relevance    :integer
#  sentiment    :float
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  entity_id    :bigint           not null
#  mention_id   :bigint           not null
#
# Indexes
#
#  index_entities_mentions_on_entity_id                 (entity_id)
#  index_entities_mentions_on_entity_id_and_mention_id  (entity_id,mention_id) UNIQUE
#  index_entities_mentions_on_mention_id                (mention_id)
#
# Foreign Keys
#
#  fk_rails_...  (entity_id => entities.id)
#  fk_rails_...  (mention_id => mentions.id)
#
require 'rails_helper'

RSpec.describe EntitiesMention, type: :model, responsible: :user do
  subject { create(:entities_mention) }

  it { is_expected.to belong_to(:entity).counter_cache(true) }
  it { is_expected.to belong_to(:mention) }
  it { is_expected.to be_valid }

  context 'with same entity_id and mention_id' do
    let(:entity) { create(:entity) }
    let(:mention) { create(:mention) }

    it 'creates only one record', aggregate_failures: true do
      expect(EntitiesMention.create(entity: entity, mention: mention)).to be_persisted
      expect(EntitiesMention.create(entity: entity, mention: mention)).not_to be_persisted
    end
  end
end
