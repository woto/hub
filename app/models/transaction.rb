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
class Transaction < ApplicationRecord
  belongs_to :debit, class_name: "Account"
  belongs_to :credit, class_name: "Account"
  belongs_to :transaction_group
  belongs_to :obj, polymorphic: true, optional: true
  belongs_to :responsible, class_name: "User"

  include Elasticable
  # include Elasticsearch::Model::Callbacks
  index_name "#{Rails.env}.transactions"

  before_save do
    self.debit_label = debit.subject.to_label
    self.credit_label = credit.subject.to_label
    self.obj_hash = obj.attributes if obj
  end

  def as_indexed_json(_options = {})
    {
        id: id,
        transaction_group_id: transaction_group.id,
        transaction_group_kind: transaction_group.kind,
        amount: amount,
        # credit.currency always equal to debit.currency
        currency: credit.currency,
        debit_amount: debit_amount,
        credit_amount: credit_amount,
        obj_id: obj_id,
        obj_type: obj_type,
        obj_hash: obj_hash,
        responsible_id: Current.responsible.id,
        credit_id: credit_id,
        credit_identifier: credit.identifier,
        credit_label: credit_label,
        credit_code: credit.code,
        credit_kind: credit.kind,
        debit_id: debit_id,
        debit_identifier: debit.identifier,
        debit_label: debit_label,
        debit_code: debit.code,
        debit_kind: debit.kind,
        created_at: created_at,
        updated_at: updated_at
    }
  end
end
