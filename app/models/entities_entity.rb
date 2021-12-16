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
class EntitiesEntity < ApplicationRecord
  belongs_to :parent, class_name: 'Entity', inverse_of: :children_entities, foreign_key: :parent_id
  belongs_to :child, class_name: 'Entity', inverse_of: :parents_entities, foreign_key: :child_id
end
