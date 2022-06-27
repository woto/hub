class RemoveMetadataIframelyFromEntities < ActiveRecord::Migration[6.1]
  def change
    remove_column :entities, :metadata_iframely, :jsonb
  end
end
