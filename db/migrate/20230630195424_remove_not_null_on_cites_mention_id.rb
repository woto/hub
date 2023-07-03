class RemoveNotNullOnCitesMentionId < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:cites, :mention_id, true)
  end
end
