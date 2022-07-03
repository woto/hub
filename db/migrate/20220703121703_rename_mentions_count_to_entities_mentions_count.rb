# TODO: remove after migration
class RenameMentionsCountToEntitiesMentionsCount < ActiveRecord::Migration[6.1]
  def change
    rename_column :entities, :mentions_count, :entities_mentions_count
  end
end
