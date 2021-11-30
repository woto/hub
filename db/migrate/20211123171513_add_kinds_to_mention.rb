class AddKindsToMention < ActiveRecord::Migration[6.1]
  def change
    add_column :mentions, :kinds, :jsonb, default: []
  end
end
