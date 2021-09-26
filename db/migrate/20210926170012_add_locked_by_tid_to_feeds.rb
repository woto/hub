class AddLockedByTidToFeeds < ActiveRecord::Migration[6.1]
  def change
    remove_column :feeds, :locked_by_pid, :string
    add_column :feeds, :locked_by_tid, :string, null: false, default: ''
  end
end
