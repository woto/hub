class AddRelevanceToEntitiesMentions < ActiveRecord::Migration[6.1]
  def change
    add_column :entities_mentions, :relevance, :integer
  end
end
