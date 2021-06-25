# frozen_string_literal: true

module Columns
  class AccountForm < BaseForm
    DEFAULTS = %w[id subjectable_label code amount subjectable_id subjectable_type created_at updated_at].freeze

    self.all_columns = [
      { key: 'id',                      pg: Account.columns_hash['id'], roles: ['user', 'manager', 'admin'] },
      { key: 'amount',                  pg: Account.columns_hash['amount'], roles: ['user', 'manager', 'admin'] },
      { key: 'currency',                pg: Account.columns_hash['currency'], as: :string, roles: ['user', 'manager', 'admin'] },
      { key: 'code',                    pg: Account.columns_hash['code'], as: :string, roles: ['user', 'manager', 'admin'] },
      { key: 'subjectable_id',          pg: Account.columns_hash['subjectable_id'], roles: ['manager', 'admin'] },
      { key: 'subjectable_type',        pg: Account.columns_hash['subjectable_type'], roles: ['manager', 'admin'] },
      { key: 'subjectable_label',       pg: Account.columns_hash['subjectable_id'], as: :string, roles: ['manager', 'admin'] },
      { key: 'created_at',              pg: Account.columns_hash['created_at'], roles: ['user', 'manager', 'admin'] },
      { key: 'updated_at',              pg: Account.columns_hash['updated_at'], roles: ['user', 'manager', 'admin'] }
    ]
  end
end
