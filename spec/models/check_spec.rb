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

  # rubocop:disable RSpec/MultipleMemoizedHelpers
  describe '#check_amount' do
    around do |example|
      admin = create(:user, role: :admin)
      Current.set(responsible: admin) do
        example.run
      end
    end

    let(:currency) { 'rub' }
    let(:user) { create(:user) }
    let(:admin) { create(:user, role: :admin) }
    let!(:post) do
      create(:post, user: user, status: :accrued, currency: currency, body: '*' * 10_000)
    end
    let(:available_amount) do
      post.amount - requested_amount - payed_amount
    end
    let(:requested_amount) do
      create(:check, user: user, status: :requested, amount: 1.23, currency: currency).amount
    end
    let(:payed_amount) do
      create(:check, user: user, status: :payed, amount: 1.23, currency: currency).amount
    end

    context 'when changes check amount' do
      let!(:check) { create(:check, user: user, amount: available_amount - 0.02, currency: currency) }

      it 'takes into account that we just change amount of this check on a new valid value' do
        check.amount = available_amount - 0.01
        expect(check).to be_valid
      end
    end

    context 'when changes currency' do
      let(:check) { create(:check, user: user, amount: available_amount - 0.01, currency: currency) }

      it 'does not increase available amount on the amount of changed check' do
        check.currency = 'usd'
        expect(check).to be_invalid
        expect(check.errors.details).to eq(
          amount: [{ count: '-$0.01', error: :less_than_or_equal_to }]
        )
      end
    end

    context 'when requested amount is less than available amount' do
      let(:check) { build(:check, user: user, amount: available_amount - 0.01, currency: currency) }

      specify do
        expect(check).to be_valid
      end
    end

    context 'when requested amount is greater than available amount' do
      let(:check) { build(:check, user: user, amount: available_amount + 0.01, currency: currency) }

      specify do
        expect(check).to be_invalid
        expect(check.errors.details).to eq(
          amount: [{
            count: GlobalHelper.decorate_money(available_amount - 0.01, currency), error: :less_than_or_equal_to
          }]
        )
      end
    end
  end
  # rubocop:enable RSpec/MultipleMemoizedHelpers

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
