class AddImageDataToMentions < ActiveRecord::Migration[6.1]
  def change
    add_column :mentions, :image_data, :jsonb
    add_index :mentions, :image_data, using: :gin
  end
end
