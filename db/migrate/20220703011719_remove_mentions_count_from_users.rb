# TODO: remove later
class RemoveMentionsCountFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :mentions_count, :integer
  end
end
