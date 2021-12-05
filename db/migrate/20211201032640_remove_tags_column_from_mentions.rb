class RemoveTagsColumnFromMentions < ActiveRecord::Migration[6.1]
  def change
    remove_column :mentions, :tags, :jsonb
  end
end
