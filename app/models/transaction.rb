# frozen_string_literal: true

# == Schema Information
#
# Table name: transactions
#
#  id                   :bigint           not null, primary key
#  amount               :decimal(, )      not null
#  credit_amount        :decimal(, )      not null
#  credit_label         :string           not null
#  debit_amount         :decimal(, )      not null
#  debit_label          :string           not null
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
  include Elasticable
  index_name "#{Rails.env}.transactions"

  belongs_to :debit, class_name: 'Account'
  belongs_to :credit, class_name: 'Account'
  belongs_to :transaction_group
  belongs_to :obj, polymorphic: true, optional: true
  belongs_to :responsible, class_name: 'User'

  # validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :amount, numericality: { greater_than: 0 }

  # NOTE: think about allowed money movements: for example for now there
  # is no way to transfer money from one user to another

  # NOTE: there were not such validations at some point
  validate :check_same_code
  validate :check_same_currency

  before_save :set_labels

  def as_indexed_json(_options = {})
    {
      id: id,
      responsible_id: responsible_id,
      amount: amount,

      transaction_group_id: transaction_group.id,
      transaction_group_kind: transaction_group.kind,

      # credit.currency always equal to debit.currency
      currency: credit.currency,
      # credit.code always equal to debit.code
      code: credit.code,

      credit_id: credit_id,
      credit_label: credit_label,
      credit_amount: credit_amount,

      debit_id: debit_id,
      debit_label: debit_label,
      debit_amount: debit_amount,

      obj_id: obj_id,
      obj_type: obj_type,
      # obj_hash: obj_hash,

      created_at: created_at,
      updated_at: updated_at
    }
  end

  private

  def check_same_code
    return if errors.include?(:credit)
    return if errors.include?(:debit)
    return if errors.include?(:base)

    errors.add(:base, :same_code_error) if credit.code != debit.code
  end

  def check_same_currency
    return if errors.include?(:credit)
    return if errors.include?(:debit)
    return if errors.include?(:base)

    errors.add(:base, :same_currency_error) if credit.currency != debit.currency
  end

  def set_labels
    # NOTE: may be better `account.to_label` instead of `account.subjectable.to_label`?
    self.debit_label = debit.subjectable.to_label
    self.credit_label = credit.subjectable.to_label

    # NOTE: getting obj.attributes is not good working because usually we create two transactions
    # and in one of them we want to get previous `obj` state, but we cant without custom serialization implementation
    # self.obj_hash = obj.attributes if obj
  end
end
