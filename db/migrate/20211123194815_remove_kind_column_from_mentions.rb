class RemoveKindColumnFromMentions < ActiveRecord::Migration[6.1]
  def change
    remove_column :mentions, :kind, :integer
  end
end
