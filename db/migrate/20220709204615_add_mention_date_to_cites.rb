class AddMentionDateToCites < ActiveRecord::Migration[6.1]
  def change
    add_column :cites, :mention_date, :datetime
  end
end
