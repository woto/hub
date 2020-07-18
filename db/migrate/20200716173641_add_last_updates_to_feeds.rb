class AddLastUpdatesToFeeds < ActiveRecord::Migration[6.0]
  def change
    add_column :feeds, :network_updated_at, :datetime
    add_column :feeds, :advertiser_updated_at, :datetime
  end
end
