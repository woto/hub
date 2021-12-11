class AddIntroToEntity < ActiveRecord::Migration[6.1]
  def change
    add_column :entities, :intro, :text
  end
end
