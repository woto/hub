# frozen_string_literal: true

module Columns
  class TransactionsMapping < BaseMapping
    DEFAULTS = %w[id transaction_group_id code credit_label credit_amount debit_label debit_amount created_at updated_at].freeze

    self.all_columns = [
      { key: 'id',                     pg: Transaction.columns_hash['id'], roles: ['user', 'manager', 'admin'] },
      { key: 'responsible_id',         pg: Account.columns_hash['id'], roles: ['user', 'manager', 'admin'] },
      { key: 'amount',                 pg: Transaction.columns_hash['amount'], roles: ['user', 'manager', 'admin'] },

      { key: 'transaction_group_id',   pg: Transaction.columns_hash['transaction_group_id'], roles: ['user', 'manager', 'admin'] },
      { key: 'transaction_group_kind', pg: TransactionGroup.columns_hash['kind'], as: :string, roles: ['user', 'manager', 'admin'] },

      { key: 'currency',               pg: Account.columns_hash['currency'], as: :string, roles: ['user', 'manager', 'admin'] },
      { key: 'code',                   pg: Account.columns_hash['code'], as: :string, roles: ['user', 'manager', 'admin'] },

      { key: 'credit_id',              pg: Transaction.columns_hash['credit_id'], roles: ['manager', 'admin'] },
      { key: 'credit_label',           pg: Transaction.columns_hash['id'], as: :string, roles: ['user', 'manager', 'admin'] },
      { key: 'credit_amount',          pg: Transaction.columns_hash['credit_amount'], roles: ['user', 'manager', 'admin'] },

      { key: 'debit_id',               pg: Transaction.columns_hash['debit_id'], as: :string, roles: ['manager', 'admin'] },
      { key: 'debit_label',            pg: Transaction.columns_hash['id'], as: :string, roles: ['user', 'manager', 'admin'] },
      { key: 'debit_amount',           pg: Transaction.columns_hash['debit_amount'], roles: ['user', 'manager', 'admin'] },

      { key: 'obj_id',              pg: Transaction.columns_hash['obj_id'], roles: ['user', 'manager', 'admin'] },
      { key: 'obj_type',            pg: Transaction.columns_hash['obj_type'], roles: ['user', 'manager', 'admin'] },

      # { key: 'obj_hash',               pg: Transaction.columns_hash['obj_hash'], roles: ['guest', 'user', 'manager', 'admin'] },

      { key: 'created_at',             pg: Transaction.columns_hash['created_at'], roles: ['user', 'manager', 'admin'] },
      { key: 'updated_at',             pg: Transaction.columns_hash['updated_at'], roles: ['user', 'manager', 'admin'] }

    ]
  end
end
