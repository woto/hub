class ChangeKindsNullValue < ActiveRecord::Migration[6.1]
  def change
    change_column_null :mentions, :kinds, false
  end
end
