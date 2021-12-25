class AddHostnameIdToTables < ActiveRecord::Migration[6.1]
  def change
    add_reference :mentions, :hostname, foreign_key: true
    add_reference :entities, :hostname, foreign_key: true
  end
end
