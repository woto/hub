class CreateOfferEmbeds < ActiveRecord::Migration[6.0]
  def change
    create_table :offer_embeds do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :url
      t.text :description
      t.string :picture

      t.timestamps
    end
  end
end
