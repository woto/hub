class CreateExchangeRates < ActiveRecord::Migration[6.0]
  def change
    create_table :exchange_rates do |t|
      t.integer :currency, null: false
      t.decimal :value, null: false
      t.date :date, null: false

      t.timestamps
    end
  end
end
