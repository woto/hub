# frozen_string_literal: true

module Columns
  class TransactionForm < BaseForm
    DEFAULTS = %w[id group credit amount debit credit_amount debit_amount].freeze

    self.all_columns = [
      { key: 'id',                    pg: Transaction.columns_hash['id'], roles: ['user', 'manager', 'admin'] },
      { key: 'group',                 pg: Transaction.columns_hash['transaction_group_id'], as: :string, roles: ['user', 'manager', 'admin'] },
      { key: 'amount',                pg: Transaction.columns_hash['amount'], roles: ['user', 'manager', 'admin'] },
      { key: 'debit_amount',          pg: Transaction.columns_hash['debit_amount'], roles: ['user', 'manager', 'admin'] },
      { key: 'credit_amount',         pg: Transaction.columns_hash['credit_amount'], roles: ['user', 'manager', 'admin'] },
      { key: 'debit',                 pg: Transaction.columns_hash['debit_id'], as: :string, roles: ['user', 'manager', 'admin'] },
      { key: 'credit',                pg: Transaction.columns_hash['credit_id'], as: :string, roles: ['user', 'manager', 'admin'] },
      { key: 'object',                pg: TransactionGroup.columns_hash['object_id'], as: :string, roles: ['user', 'manager', 'admin'] },
      { key: 'created_at',            pg: Transaction.columns_hash['created_at'], roles: ['user', 'manager', 'admin'] },
      { key: 'updated_at',            pg: Transaction.columns_hash['updated_at'], roles: ['user', 'manager', 'admin'] }
    ]
  end
end
