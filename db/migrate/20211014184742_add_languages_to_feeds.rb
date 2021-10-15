class AddLanguagesToFeeds < ActiveRecord::Migration[6.1]
  def change
    add_column :feeds, :languages, :jsonb, default: {}
  end
end
