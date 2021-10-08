class AddTrackersToRealms < ActiveRecord::Migration[6.1]
  def change
    add_column :realms, :after_head_open, :text
    add_column :realms, :before_head_close, :text
    add_column :realms, :after_body_open, :text
    add_column :realms, :before_body_close, :text
  end
end
