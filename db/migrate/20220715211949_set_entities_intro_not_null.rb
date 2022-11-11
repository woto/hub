class SetEntitiesIntroNotNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :entities, :intro, null: false
  end
end
