class CreateExchangeRates < ActiveRecord::Migration[6.0]
  def change
    create_table :exchange_rates do |t|
      t.jsonb :currencies, null: false
      t.date :date, null: false
      t.jsonb :extra_options, null: false

      t.timestamps
    end
  end
end
