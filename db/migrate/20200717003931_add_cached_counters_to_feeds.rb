class AddCachedCountersToFeeds < ActiveRecord::Migration[6.0]
  def change
    add_column :feeds, :offers_count, :integer
    add_column :feeds, :categories_count, :integer
  end
end
