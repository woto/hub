# == Schema Information
#
# Table name: transactions
#
#  id                   :bigint           not null, primary key
#  amount               :decimal(, )      not null
#  credit_amount        :decimal(, )      not null
#  credit_label         :string
#  debit_amount         :decimal(, )      not null
#  debit_label          :string
#  obj_hash             :jsonb
#  obj_type             :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  credit_id            :bigint           not null
#  debit_id             :bigint           not null
#  obj_id               :bigint
#  responsible_id       :bigint           not null
#  transaction_group_id :bigint           not null
#
# Indexes
#
#  index_transactions_on_credit_id             (credit_id)
#  index_transactions_on_debit_id              (debit_id)
#  index_transactions_on_obj_type_and_obj_id   (obj_type,obj_id)
#  index_transactions_on_responsible_id        (responsible_id)
#  index_transactions_on_transaction_group_id  (transaction_group_id)
#
# Foreign Keys
#
#  fk_rails_...  (credit_id => accounts.id)
#  fk_rails_...  (debit_id => accounts.id)
#  fk_rails_...  (responsible_id => users.id)
#  fk_rails_...  (transaction_group_id => transaction_groups.id)
#
require 'rails_helper'

describe Transaction, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
