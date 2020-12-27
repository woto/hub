# frozen_string_literal: true

module Columns
  class AccountForm < BaseForm
    DEFAULTS = %w[id subject_label code identifier comment amount currency kind subject_id subject_type created_at updated_at].freeze

    self.all_columns = [
      { key: 'id',                      pg: Account.columns_hash['id'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'amount',                  pg: Account.columns_hash['amount'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'currency',                pg: Account.columns_hash['currency'], as: :string, roles: ['manager', 'admin'] },
      { key: 'kind',                    pg: Account.columns_hash['kind'], as: :string, roles: ['manager', 'admin'] },
      { key: 'identifier',              pg: Account.columns_hash['identifier'], roles: ['manager', 'admin'] },
      { key: 'comment',                 pg: Account.columns_hash['comment'], roles: ['manager', 'admin'] },
      { key: 'code',                    pg: Account.columns_hash['code'], as: :string, roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'subject_id',              pg: Account.columns_hash['subject_id'], roles: ['manager', 'admin'] },
      { key: 'subject_type',            pg: Account.columns_hash['subject_type'], roles: ['manager', 'admin'] },
      { key: 'subject_label',           pg: Account.columns_hash['subject_id'], as: :string, roles: ['manager', 'admin'] },
      { key: 'created_at',              pg: Account.columns_hash['created_at'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'updated_at',              pg: Account.columns_hash['updated_at'], roles: ['guest', 'user', 'manager', 'admin'] }
    ]
  end
end
