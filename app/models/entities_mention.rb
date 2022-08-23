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
class EntitiesMention < ApplicationRecord
  belongs_to :entity, counter_cache: true
  belongs_to :mention

  validates :entity, uniqueness: { scope: :mention }
end
