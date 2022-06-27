class RemoveMetadataYandexFromMentions < ActiveRecord::Migration[6.1]
  def change
    remove_column :mentions, :metadata_yandex, :jsonb
  end
end
