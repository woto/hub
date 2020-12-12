class CreateRealms < ActiveRecord::Migration[6.0]
  def change
    create_table :realms do |t|
      # t.jsonb :title_i18n
      t.string :title, null: false
      t.string :locale, null: false
      t.integer :kind, null: false
      t.timestamps
    end
  end
end
