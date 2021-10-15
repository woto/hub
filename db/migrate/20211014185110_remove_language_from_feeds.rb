class RemoveLanguageFromFeeds < ActiveRecord::Migration[6.1]
  def change
    remove_column :feeds, :language, :string
  end
end
