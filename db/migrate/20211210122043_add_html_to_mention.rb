class AddHtmlToMention < ActiveRecord::Migration[6.1]
  def change
    add_column :mentions, :html, :text
  end
end
