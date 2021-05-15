# frozen_string_literal: true

require 'rails_helper'

describe Accounting::Main::PostStatusPolicy, type: :policy do
  subject { described_class }

  let(:policy_context) { Accounting::Main::StatusContext.new(obj: build(:post), from_status: from_status) }

  context 'without user' do
    let(:user) { nil }
    let(:from_status) { nil }

    it 'raises error' do
      expect {
        described_class.new(user, policy_context)
      }.to raise_error(Pundit::NotAuthorizedError, 'responsible is not set')
    end
  end

  context 'with user' do
    let(:user) { build(:user) }

    context 'when `from_status` is `nil`' do
      let(:from_status) { nil }

      permissions :to_approved?, :to_rejected?, :to_accrued?, :to_canceled? do
        it { is_expected.not_to permit(user, policy_context) }
      end

      permissions :to_draft?, :to_pending? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `draft`' do
      let(:from_status) { 'draft' }

      permissions :to_approved?, :to_rejected?, :to_accrued?, :to_canceled? do
        it { is_expected.not_to permit(user, policy_context) }
      end

      permissions :to_draft?, :to_pending? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `pending`' do
      let(:from_status) { 'pending' }

      permissions :to_approved?, :to_rejected?, :to_accrued?, :to_canceled? do
        it { is_expected.not_to permit(user, policy_context) }
      end

      permissions :to_draft?, :to_pending? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `approved`' do
      let(:from_status) { 'approved' }

      permissions :to_draft?, :to_pending?, :to_approved?, :to_rejected?, :to_accrued?, :to_canceled? do
        it { is_expected.not_to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `rejected`' do
      let(:from_status) { 'rejected' }

      permissions :to_draft?, :to_pending? do
        it { is_expected.to permit(user, policy_context) }
      end

      permissions :to_approved?, :to_rejected?, :to_accrued?, :to_canceled? do
        it { is_expected.not_to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `accrued`' do
      let(:from_status) { 'accrued' }

      permissions :to_draft?, :to_pending?, :to_approved?, :to_rejected?, :to_accrued?, :to_canceled? do
        it { is_expected.not_to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `canceled`' do
      let(:from_status) { 'canceled' }

      permissions :to_draft?, :to_pending?, :to_approved?, :to_rejected?, :to_accrued?, :to_canceled? do
        it { is_expected.not_to permit(user, policy_context) }
      end
    end
  end

  context 'with admin' do
    let(:user) { build(:user, role: :admin) }

    context 'when `from_status` is `nil`' do
      let(:from_status) { nil }

      permissions :to_draft?, :to_pending?, :to_approved?, :to_rejected?, :to_accrued?, :to_canceled? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `draft`' do
      let(:from_status) { 'draft' }

      permissions :to_draft?, :to_pending?, :to_approved?, :to_rejected?, :to_accrued?, :to_canceled? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `pending`' do
      let(:from_status) { 'pending' }

      permissions :to_draft?, :to_pending?, :to_approved?, :to_rejected?, :to_accrued?, :to_canceled? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `approved`' do
      let(:from_status) { 'approved' }

      permissions :to_draft?, :to_pending?, :to_approved?, :to_rejected?, :to_accrued?, :to_canceled? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `rejected`' do
      let(:from_status) { 'rejected' }

      permissions :to_draft?, :to_pending?, :to_approved?, :to_rejected?, :to_accrued?, :to_canceled? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `accrued`' do
      let(:from_status) { 'accrued' }

      permissions :to_draft?, :to_pending?, :to_approved?, :to_rejected?, :to_accrued?, :to_canceled? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `canceled`' do
      let(:from_status) { 'canceled' }

      permissions :to_draft?, :to_pending?, :to_approved?, :to_rejected?, :to_accrued?, :to_canceled? do
        it { is_expected.to permit(user, policy_context) }
      end
    end
  end
end
