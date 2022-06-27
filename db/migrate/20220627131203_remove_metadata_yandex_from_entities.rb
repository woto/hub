class RemoveMetadataYandexFromEntities < ActiveRecord::Migration[6.1]
  def change
    remove_column :entities, :metadata_yandex, :jsonb
  end
end
