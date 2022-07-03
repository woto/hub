# TODO: remove after migration
class AddTopicsCountToMentions < ActiveRecord::Migration[6.1]
  def change
    add_column :mentions, :topics_count, :integer, default: 0, null: false
  end
end
