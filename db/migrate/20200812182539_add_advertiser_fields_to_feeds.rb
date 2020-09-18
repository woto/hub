# frozen_string_literal: true

class AddAdvertiserFieldsToFeeds < ActiveRecord::Migration[6.0]
  def change
    add_column :feed_logs, :feed_advertiser_name_before, :string
    add_column :feed_logs, :feed_advertiser_name_after, :string
  end
end
