class AddLogidzeToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :log_data, :jsonb

    reversible do |dir|
      dir.up do
        execute <<~SQL
          CREATE TRIGGER logidze_on_accounts
          BEFORE UPDATE OR INSERT ON accounts FOR EACH ROW
          WHEN (coalesce(current_setting('logidze.disabled', true), '') <> 'on')
          -- Parameters: history_size_limit (integer), timestamp_column (text), filtered_columns (text[]),
          -- include_columns (boolean), debounce_time_ms (integer)
          EXECUTE PROCEDURE logidze_logger(10, 'updated_at');

        SQL
      end

      dir.down do
        execute "DROP TRIGGER IF EXISTS logidze_on_accounts on accounts;"
      end
    end
  end
end
