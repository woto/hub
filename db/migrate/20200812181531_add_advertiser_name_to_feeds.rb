# frozen_string_literal: true

class AddAdvertiserNameToFeeds < ActiveRecord::Migration[6.0]
  def change
    add_column :feeds, :advertiser_name, :string
  end
end
