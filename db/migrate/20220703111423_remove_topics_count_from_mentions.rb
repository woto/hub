# TODO: remove after migration
class RemoveTopicsCountFromMentions < ActiveRecord::Migration[6.1]
  def change
    remove_column :mentions, :topics_count, :integer
  end
end
