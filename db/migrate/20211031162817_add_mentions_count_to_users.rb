class AddMentionsCountToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :mentions_count, :integer, default: 0, null: false
  end
end
