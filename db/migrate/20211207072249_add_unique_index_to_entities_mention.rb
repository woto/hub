# frozen_string_literal: true

class AddUniqueIndexToEntitiesMention < ActiveRecord::Migration[6.1]
  def change
    add_index :entities_mentions, %i[entity_id mention_id], unique: true
  end
end
