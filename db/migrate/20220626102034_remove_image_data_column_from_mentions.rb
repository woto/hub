class RemoveImageDataColumnFromMentions < ActiveRecord::Migration[6.1]
  def change
    remove_column :mentions, :image_data, :jsonb
  end
end
