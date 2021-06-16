# frozen_string_literal: true

class CreateRealms < ActiveRecord::Migration[6.0]
  def change
    create_table :realms do |t|
      t.string :title, null: false, index: { unique: true }
      t.string :locale, null: false
      t.integer :kind, null: false
      t.integer :posts_count, default: 0, null: false
      t.integer :post_categories_count, default: 0, null: false
      t.string :domain, null: false, index: { unique: true }
      t.timestamps
    end

    add_index :realms, %i[locale kind], unique: true, where: 'kind != 0'
    # add_index :realms, :domain, unique: true
    # add_index :realms, :title, unique: true
  end
end
