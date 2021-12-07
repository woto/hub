class AddTitleToMention < ActiveRecord::Migration[6.1]
  def change
    add_column :mentions, :title, :string
  end
end
