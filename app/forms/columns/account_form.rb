# frozen_string_literal: true

module Columns
  class AccountForm < BaseForm
    DEFAULTS = %w[id subject code name kind amount].freeze

    self.all_columns = [
      { key: 'id',                      pg: Account.columns_hash['id'], roles: ['user', 'manager', 'admin'] },
      { key: 'amount',                  pg: Account.columns_hash['amount'], roles: ['user', 'manager', 'admin'] },
      { key: 'currency',                pg: Account.columns_hash['currency'], as: :string, roles: ['user', 'manager', 'admin'] },
      { key: 'kind',                    pg: Account.columns_hash['kind'], as: :string, roles: ['user', 'manager', 'admin'] },
      { key: 'name',                    pg: Account.columns_hash['name'], roles: ['user', 'manager', 'admin'] },
      { key: 'code',                    pg: Account.columns_hash['code'], as: :string, roles: ['user', 'manager', 'admin'] },
      { key: 'subject',                 pg: Account.columns_hash['id'], as: :string, roles: ['user', 'manager', 'admin'] },
      { key: 'created_at',              pg: Account.columns_hash['created_at'], roles: ['user', 'manager', 'admin'] },
      { key: 'updated_at',              pg: Account.columns_hash['updated_at'], roles: ['user', 'manager', 'admin'] }
    ]
  end
end
