class AddMentionsCountToExchangeRates < ActiveRecord::Migration[6.1]
  def change
    add_column :exchange_rates, :mentions_count, :integer, default: 0, null: false
  end
end
