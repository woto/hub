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
require 'rails_helper'

describe Transaction, type: :model do
  it_behaves_like 'elasticable'

  it { is_expected.to belong_to(:credit).class_name('Account') }
  it { is_expected.to belong_to(:debit).class_name('Account') }
  it { is_expected.to belong_to(:transaction_group) }
  it { is_expected.to belong_to(:obj).optional }
  it { is_expected.to belong_to(:responsible).class_name('User') }
  it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }

  describe '#check_same_code' do
    context 'when accounts have different codes' do
      subject(:transaction) { build(:transaction, credit: credit, debit: debit) }

      let(:credit) { create(:account, currency: currency, code: :draft) }
      let(:debit) { create(:account, currency: currency, code: :pending) }
      let(:currency) { :rub }

      it 'is invalid' do
        expect(subject).to be_invalid
        expect(subject.errors.details).to eq({ base: [{ error: :same_code_error }] })
      end
    end
  end

  describe '#check_same_currency' do
    subject(:transaction) { build(:transaction, credit: credit, debit: debit) }

    let(:credit) { create(:account, code: code, currency: :rub) }
    let(:debit) { create(:account, code: code, currency: :usd) }
    let(:code) { :draft }

    it 'is invalid' do
      expect(subject).to be_invalid
      expect(subject.errors.details).to eq({ base: [{ error: :same_currency_error }] })
    end
  end

  describe '#set_labels' do
    subject(:transaction) { create(:transaction) }

    it 'sets credit_label and debit_label with correct values' do
      expect(transaction.credit_label).to eq(transaction.credit.subjectable.to_label)
      expect(transaction.debit_label).to eq(transaction.debit.subjectable.to_label)
    end
  end

  describe '#as_indexed_json' do
    subject { transaction.as_indexed_json }

    let(:transaction) { create(:transaction) }

    it {
      expect(subject).to include(
        id: transaction.id,
        responsible_id: transaction.responsible_id,
        amount: transaction.amount,
        transaction_group_id: transaction.transaction_group.id,
        transaction_group_kind: transaction.transaction_group.kind,
        currency: transaction.credit.currency,
        code: transaction.credit.code,
        credit_id: transaction.credit_id,
        credit_label: transaction.credit_label,
        credit_amount: transaction.credit_amount,
        debit_id: transaction.debit_id,
        debit_label: transaction.debit_label,
        debit_amount: transaction.debit_amount,
        obj_id: transaction.obj_id,
        obj_type: transaction.obj_type
      )
    }
  end
end
