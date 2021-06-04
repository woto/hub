# frozen_string_literal: true

require 'rails_helper'

describe Accounting::Main::CheckStatusPolicy, type: :policy do
  subject { described_class }

  let(:policy_context) { Accounting::Main::StatusContext.new(record: build(:post), from_status: from_status) }

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

      permissions :to_payed_check?, :to_approved_check?, :to_removed_check? do
        it { is_expected.not_to permit(user, policy_context) }
      end

      permissions :to_pending_check? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `pending_check`' do
      let(:from_status) { 'pending_check' }

      permissions :to_payed_check?, :to_approved_check? do
        it { is_expected.not_to permit(user, policy_context) }
      end

      permissions :to_pending_check?, :to_removed_check? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `approved_check`' do
      let(:from_status) { 'approved_check' }

      permissions :to_pending_check?, :to_approved_check?, :to_payed_check?, :to_removed_check? do
        it { is_expected.not_to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `payed_check`' do
      let(:from_status) { 'payed_check' }

      permissions :to_pending_check?, :to_approved_check?, :to_payed_check?, :to_removed_check? do
        it { is_expected.not_to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `removed_check`' do
      let(:from_status) { 'removed_check' }

      permissions :to_pending_check?, :to_approved_check?, :to_payed_check?, :to_removed_check? do
        it { is_expected.not_to permit(user, policy_context) }
      end
    end
  end

  context 'with admin' do
    let(:user) { build(:user, role: :admin) }

    context 'when `from_status` is `nil`' do
      let(:from_status) { nil }

      permissions :to_pending_check?, :to_approved_check?, :to_payed_check?, :to_removed_check? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `pending_check`' do
      let(:from_status) { 'pending_check' }

      permissions :to_pending_check?, :to_approved_check?, :to_payed_check?, :to_removed_check? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `approved_check`' do
      let(:from_status) { 'approved_check' }

      permissions :to_pending_check?, :to_approved_check?, :to_payed_check?, :to_removed_check? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `payed_check`' do
      let(:from_status) { 'payed_check' }

      permissions :to_pending_check?, :to_approved_check?, :to_payed_check?, :to_removed_check? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `removed_check`' do
      let(:from_status) { 'removed_check' }

      permissions :to_pending_check?, :to_approved_check?, :to_payed_check?, :to_removed_check? do
        it { is_expected.to permit(user, policy_context) }
      end
    end
  end
end
