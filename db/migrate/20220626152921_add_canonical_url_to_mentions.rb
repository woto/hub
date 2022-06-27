class AddCanonicalUrlToMentions < ActiveRecord::Migration[6.1]
  def change
    add_column :mentions, :canonical_url, :text
  end
end
