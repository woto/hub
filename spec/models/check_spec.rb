# frozen_string_literal: true

# == Schema Information
#
# Table name: checks
#
#  id           :bigint           not null, primary key
#  amount       :decimal(, )      not null
#  currency     :integer          not null
#  lock_version :integer          not null
#  status       :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_checks_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

describe Check, type: :model do
  context 'with mocked `check_amount`' do
    before do
      allow_any_instance_of(described_class).to receive(:check_amount)
    end

    it_behaves_like 'logidzable'
    it_behaves_like 'elasticable'
  end

  it { is_expected.to belong_to(:user).counter_cache(true).touch(true) }
  it { is_expected.to define_enum_for(:currency).with_values(GlobalHelper.currencies_table) }
  it { is_expected.to define_enum_for(:status).with_values(%w[requested processing payed]) }
  it { is_expected.to have_many(:transactions) }
  it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
  it { is_expected.to validate_presence_of(:status) }
  it { is_expected.to validate_presence_of(:currency) }

  # rubocop:disable RSpec/NestedGroups
  describe '#check_amount' do
    let(:currency) { 'eur' }
    let(:user) { create(:user) }

    context 'when check is persisted' do
      before do
        # On the first invocation amount is 10 (in let! block)
        expect(Account).to receive(:available_to_request).with(user, currency).and_return(10)
        # On the second one amount is 8 less (because check was requested)
        expect(Account).to receive(:available_to_request).with(user, currency).and_return(2)
      end

      let!(:check) do
        Current.set(responsible: create(:user, role: :admin)) do
          create(:check, user: user, amount: 8, currency: currency)
        end
      end

      context 'when `amount` (9) is less than `Account.available_to_request` (2) + sum of processed check (8)' do
        it 'does not take into account amount of processed check' do
          check.amount = 9
          expect(check).to be_valid
        end
      end

      context 'when `amount (11)` is greater than `Account.available_to_request` (2) + sum of processed check (8)' do
        it 'does not take into account amount of processed check' do
          check.amount = 11
          expect(check).to be_invalid
        end
      end
    end

    context 'when check is not persisted' do
      before do
        expect(Account).to receive(:available_to_request).with(user, currency).and_return(10)
      end

      let(:check) { build(:check, user: user, amount: amount, currency: currency) }

      context 'when `amount` is less than `Account.available_to_request`' do
        let(:amount) { 9 }

        it 'passes validation' do
          expect(check).to be_valid
        end
      end

      context 'when `amount` is greater than `Account.available_to_request`' do
        let(:amount) { 11 }

        it 'passes validation' do
          expect(check).to be_invalid
          expect(check.errors.details).to eq({ amount: [{ count: '€9,99', error: :less_than_or_equal_to }] })
        end
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups

  describe '#as_indexed_json' do
    subject { Current.set(responsible: create(:user)) { check.as_indexed_json } }

    before do
      allow_any_instance_of(described_class).to receive(:check_amount)
    end

    let(:check) { create(:check) }

    it 'returns correct result' do
      expect(subject).to include(
        id: check.id,
        amount: check.amount,
        currency: check.currency,
        status: check.status,
        user_id: check.user_id
      )
    end
  end

  describe '#create_transactions' do
    before do
      allow_any_instance_of(described_class).to receive(:check_amount)
    end

    context 'when check is not persisted yet' do
      subject { build(:check, status: described_class.statuses.keys.sample) }

      it 'calls `Accounting::Main::ChangeStatus` with correct params' do
        expect(Accounting::Main::ChangeStatus).to receive(:call).with(record: subject)
        expect(subject.save).to be_truthy
      end
    end

    context 'when check already persisted' do
      subject! { Current.set(responsible: user) { create(:check, user: user) } }

      let(:user) { create(:user) }
      let(:status) { described_class.statuses.keys.excluding(subject.status).sample }

      it 'calls `Accounting::Main::ChangeStatus` with correct params' do
        expect(Accounting::Main::ChangeStatus).to receive(:call).with(record: subject)
        expect(subject.update(status: status)).to be_truthy
      end
    end

    context 'when `ActiveRecord::ActiveRecordError` occurs' do
      it 're-raises error to break transaction' do
        expect(Accounting::Main::ChangeStatus).to receive(:call).and_raise(ActiveRecord::ActiveRecordError, 'aaa')
        expect(Rails.logger).to receive(:error)
        expect { create(:check) }.to raise_error(StandardError, 'aaa')
      end
    end
  end
end
