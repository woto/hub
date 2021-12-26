class AddMetadataToTables < ActiveRecord::Migration[6.1]
  def change
    add_column :entities, :metadata_yandex, :jsonb
    add_column :mentions, :metadata_yandex, :jsonb
    add_column :entities, :metadata_iframely, :jsonb
    add_column :mentions, :metadata_iframely, :jsonb
  end
end
