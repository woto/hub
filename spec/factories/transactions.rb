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
FactoryBot.define do
  factory :transaction do
    transient do
      code { Account.codes.keys.sample }
      currency { Rails.configuration.available_currencies.excluding(['ghc']).sample }
      # Not sure that `create` is correct way.
      # But otherwise it fails on getting account for this user
      user { create(:user) }
    end
    credit { Account.for_subject('hub', code, currency) }
    debit { Account.for_user(user, code, currency) }
    amount { Faker::Number.positive }
    credit_amount { Faker::Number.positive }
    debit_amount { Faker::Number.positive }
    transaction_group
    responsible { user }
    # Don't user `obj` here, because creating object will
    # create transaction (at least true for Post and Check)
  end
end
