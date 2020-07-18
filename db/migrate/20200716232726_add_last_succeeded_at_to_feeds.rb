class AddLastSucceededAtToFeeds < ActiveRecord::Migration[6.0]
  def change
    add_column :feeds, :last_succeeded_at, :datetime
  end
end
