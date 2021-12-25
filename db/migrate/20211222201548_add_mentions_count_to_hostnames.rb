class AddMentionsCountToHostnames < ActiveRecord::Migration[6.1]
  def change
    add_column :hostnames, :mentions_count, :integer, default: 0, null: false
  end
end
