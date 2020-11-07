# == Schema Information
#
# Table name: transactions
#
#  id                   :bigint           not null, primary key
#  amount               :integer          not null
#  credit_amount        :integer          not null
#  debit_amount         :integer          not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  credit_id            :bigint           not null
#  debit_id             :bigint           not null
#  transaction_group_id :bigint           not null
#
# Indexes
#
#  index_transactions_on_credit_id             (credit_id)
#  index_transactions_on_debit_id              (debit_id)
#  index_transactions_on_transaction_group_id  (transaction_group_id)
#
# Foreign Keys
#
#  fk_rails_...  (credit_id => accounts.id)
#  fk_rails_...  (debit_id => accounts.id)
#  fk_rails_...  (transaction_group_id => transaction_groups.id)
#
class Transaction < ApplicationRecord
  belongs_to :debit, class_name: "Account"
  belongs_to :credit, class_name: "Account"
  belongs_to :transaction_group

  include Elasticable
  # include Elasticsearch::Model::Callbacks
  index_name "#{Rails.env}.transactions"

  def as_indexed_json(_options = {})
    {
        id: id,
        group: "##{transaction_group.id} #{transaction_group.to_label}",
        amount: amount,
        debit_amount: debit_amount,
        credit_amount: credit_amount,
        object: "##{transaction_group.object&.id} #{transaction_group.object&.to_label}",
        debit: "##{debit.id} #{debit.to_label}",
        credit: "##{credit.id} #{credit.to_label}",
        created_at: created_at,
        updated_at: updated_at
    }
  end
end
