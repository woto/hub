class RemoveMetadataIframelyFromMentions < ActiveRecord::Migration[6.1]
  def change
    remove_column :mentions, :metadata_iframely, :jsonb
  end
end
