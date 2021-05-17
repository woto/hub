# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/MultipleMemoizedHelpers
describe Accounting::CreateTransaction do
  subject do
    described_class.call(credit: credit, debit: debit, group: group, amount: amount, obj: obj, currency: obj_currency)
  end

  let(:admin) { create(:user, role: :admin) }
  let(:currency) { %w[usd eur rub].sample }
  let(:credit_currency) { currency }
  let(:debit_currency) { currency }
  let(:obj_currency) { currency }

  let(:code) { Account.codes.keys.sample }
  let(:debit_code) { code }
  let(:credit_code) { code }

  let(:credit) { create(:account, code: credit_code, currency: credit_currency) }
  let(:debit) { create(:account, code: debit_code, currency: debit_currency) }

  let(:group) { create(:transaction_group) }
  let(:amount) { rand(100).to_d }

  let(:obj) do
    Current.set(responsible: admin) do
      post = create(:post, currency: obj_currency)
      { id: post.id, type: post.class.name }
    end
  end

  describe 'contract' do
    context 'when `credit` is not an Account' do
      let(:credit) { 1 }

      specify do
        expect { subject }.to raise_error(StandardError, { "credit": ['must be Account'] }.to_json)
      end
    end

    context 'when `debit` is not an Account' do
      let(:debit) { 1 }

      specify do
        expect { subject }.to raise_error(StandardError, { "debit": ['must be Account'] }.to_json)
      end
    end

    context 'when `group` is not a TransactionGroup' do
      let(:group) { 1 }

      specify do
        expect { subject }.to raise_error(StandardError, { "group": ['must be TransactionGroup'] }.to_json)
      end
    end

    context 'when `amount` is not a BigDecimal' do
      let(:amount) { 1 }

      specify do
        expect { subject }.to raise_error(StandardError, { "amount": ['must be BigDecimal'] }.to_json)
      end
    end

    context 'when `obj` is nil' do
      let(:obj) { nil }

      specify do
        expect(Transaction).to receive(:create!)
        expect { subject }.not_to raise_error
      end
    end

    context 'when `credit` and `debit` have different codes' do
      let(:debit_code) { Account.codes.keys.excluding(credit.code).sample }

      specify do
        expect { subject }.to raise_error(StandardError, { "credit": ['must have same codes'] }.to_json)
      end
    end

    context 'when `credit.currency` differs from others' do
      let(:credit_currency) { Rails.configuration.available_currencies.excluding(['ghc', currency]).sample }

      specify do
        expect { subject }.to raise_error(StandardError, { "credit": ['must have same currencies'] }.to_json)
      end
    end

    context 'when `debit.currency` differs from others' do
      let(:debit_currency) { Rails.configuration.available_currencies.excluding(['ghc', currency]).sample }

      specify do
        expect { subject }.to raise_error(StandardError, { "credit": ['must have same currencies'] }.to_json)
      end
    end

    context 'when `obj.currency` differs from others' do
      let(:obj_currency) { Rails.configuration.available_currencies.excluding(['ghc', currency]).sample }

      specify do
        expect { subject }.to raise_error(StandardError, { "credit": ['must have same currencies'] }.to_json)
      end
    end

    context 'when `amount` is less than zero' do
      let(:amount) { -rand(100).to_d }

      specify do
        expect { subject }.to raise_error(StandardError, { "amount": ['must be equal or greater than 0'] }.to_json)
      end
    end
  end

  it 'creates Transaction with correct attributes' do
    Account.where(id: credit.id).update_all(amount: 123)
    Account.where(id: debit.id).update_all(amount: 456)

    expect(Transaction).to receive(:create!).with(
      credit: credit,
      credit_amount: credit.reload.amount - amount,
      debit: debit,
      debit_amount: debit.reload.amount + amount,
      transaction_group: group,
      amount: amount,
      obj_id: obj[:id],
      obj_type: obj[:type],
      responsible: admin
    )

    Current.set(responsible: admin) do
      expect(subject).to be_success
    end
  end

  it 'updates `credit.amount`' do
    Account.where(id: credit.id).update_all(amount: 123)

    Current.set(responsible: admin) do
      expect { subject }.to change { credit.reload.amount }.from(123).to(123 - amount)
    end
  end

  it 'updates `debit.amount`' do
    Account.where(id: debit.id).update_all(amount: 456)

    Current.set(responsible: admin) do
      expect { subject }.to change { debit.reload.amount }.from(456).to(456 + amount)
    end
  end

  it 'indexes documents' do
    obj

    expect(Account.__elasticsearch__).to receive(:import) do |arg|
      expect(arg[:query].call.ids).to eq([credit.id, debit.id])
    end

    Current.set(responsible: admin) do
      subject
    end
  end
end
