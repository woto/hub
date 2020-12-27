# frozen_string_literal: true

module Columns
  class TransactionForm < BaseForm
    DEFAULTS = %w[id transaction_group_kind transaction_group_id credit_label credit_code credit_identifier amount debit_label debit_code debit_identifier created_at updated_at].freeze

    self.all_columns = [
      { key: 'id',                     pg: Transaction.columns_hash['id'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'transaction_group_id',   pg: Transaction.columns_hash['transaction_group_id'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'transaction_group_kind', pg: TransactionGroup.columns_hash['kind'], as: :string, roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'obj_id',                 pg: Transaction.columns_hash['obj_id'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'obj_type',               pg: Transaction.columns_hash['obj_type'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'obj_hash',               pg: Transaction.columns_hash['obj_hash'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'responsible_id',         pg: Account.columns_hash['id'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'credit_id',              pg: Transaction.columns_hash['credit_id'], roles: ['manager', 'admin'] },
      { key: 'credit_identifier',      pg: Account.columns_hash['identifier'], as: :string, roles: ['manager', 'admin'] },
      { key: 'credit_code',            pg: Account.columns_hash['code'], as: :string, roles: ['manager', 'admin'] },
      { key: 'credit_kind',            pg: Account.columns_hash['kind'], as: :string, roles: ['manager', 'admin'] },
      { key: 'credit_amount',          pg: Transaction.columns_hash['credit_amount'], roles: ['manager', 'admin'] },
      { key: 'credit_label',           pg: Transaction.columns_hash['id'], as: :string, roles: ['manager', 'admin'] },
      { key: 'debit_id',               pg: Transaction.columns_hash['debit_id'], as: :string, roles: ['manager', 'admin'] },
      { key: 'debit_identifier',       pg: Account.columns_hash['identifier'], as: :string, roles: ['manager', 'admin'] },
      { key: 'debit_code',             pg: Account.columns_hash['code'], as: :string, roles: ['manager', 'admin'] },
      { key: 'debit_kind',             pg: Account.columns_hash['kind'], as: :string, roles: ['manager', 'admin'] },
      { key: 'debit_label',            pg: Transaction.columns_hash['id'], as: :string, roles: ['manager', 'admin'] },
      { key: 'debit_amount',           pg: Transaction.columns_hash['debit_amount'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'amount',                 pg: Transaction.columns_hash['amount'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'currency',               pg: Account.columns_hash['currency'], as: :string, roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'created_at',             pg: Transaction.columns_hash['created_at'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'updated_at',             pg: Transaction.columns_hash['updated_at'], roles: ['guest', 'user', 'manager', 'admin'] }
    ]
  end
end
