# frozen_string_literal: true

require 'rails_helper'

describe Accounting::Main::MentionStatusPolicy, type: :policy do
  subject { described_class }

  let(:policy_context) { Accounting::Main::StatusContext.new(record: build(:mention), from_status: from_status) }

  context 'without user' do
    let(:user) { nil }
    let(:from_status) { nil }

    it 'raises error' do
      expect do
        described_class.new(user, policy_context)
      end.to raise_error(Pundit::NotAuthorizedError, 'responsible is not set')
    end
  end

  context 'with user' do
    let(:user) { build(:user) }

    context 'when `from_status` is `nil`' do
      let(:from_status) { nil }

      permissions :to_approved_mention?, :to_rejected_mention?, :to_accrued_mention?, :to_canceled_mention?, :to_removed_mention? do
        it { is_expected.not_to permit(user, policy_context) }
      end

      permissions :to_draft_mention?, :to_pending_mention? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `draft_mention`' do
      let(:from_status) { 'draft_mention' }

      permissions :to_approved_mention?, :to_rejected_mention?, :to_accrued_mention?, :to_canceled_mention? do
        it { is_expected.not_to permit(user, policy_context) }
      end

      permissions :to_draft_mention?, :to_pending_mention?, :to_removed_mention? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `pending_mention`' do
      let(:from_status) { 'pending_mention' }

      permissions :to_approved_mention?, :to_rejected_mention?, :to_accrued_mention?, :to_canceled_mention? do
        it { is_expected.not_to permit(user, policy_context) }
      end

      permissions :to_draft_mention?, :to_pending_mention?, :to_removed_mention? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `approved_mention`' do
      let(:from_status) { 'approved_mention' }

      permissions :to_draft_mention?, :to_pending_mention?, :to_approved_mention?, :to_rejected_mention?, :to_accrued_mention?,
                  :to_canceled_mention?, :to_removed_mention? do
        it { is_expected.not_to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `rejected_mention`' do
      let(:from_status) { 'rejected_mention' }

      permissions :to_draft_mention?, :to_pending_mention?, :to_removed_mention? do
        it { is_expected.to permit(user, policy_context) }
      end

      permissions :to_approved_mention?, :to_rejected_mention?, :to_accrued_mention?, :to_canceled_mention? do
        it { is_expected.not_to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `accrued_mention`' do
      let(:from_status) { 'accrued_mention' }

      permissions :to_draft_mention?, :to_pending_mention?, :to_approved_mention?, :to_rejected_mention?, :to_accrued_mention?,
                  :to_canceled_mention?, :to_removed_mention? do
        it { is_expected.not_to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `canceled_mention`' do
      let(:from_status) { 'canceled_mention' }

      permissions :to_draft_mention?, :to_pending_mention?, :to_approved_mention?, :to_rejected_mention?, :to_accrued_mention?,
                  :to_canceled_mention?, :to_removed_mention? do
        it { is_expected.not_to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `removed_mention`' do
      let(:from_status) { 'removed_mention' }

      permissions :to_draft_mention?, :to_pending_mention?, :to_approved_mention?, :to_rejected_mention?, :to_accrued_mention?,
                  :to_canceled_mention?, :to_removed_mention? do
        it { is_expected.not_to permit(user, policy_context) }
      end
    end
  end

  context 'with admin' do
    let(:user) { build(:user, role: :admin) }

    context 'when `from_status` is `nil`' do
      let(:from_status) { nil }

      permissions :to_draft_mention?, :to_pending_mention?, :to_approved_mention?, :to_rejected_mention?, :to_accrued_mention?,
                  :to_canceled_mention?, :to_removed_mention? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `draft_mention`' do
      let(:from_status) { 'draft_mention' }

      permissions :to_draft_mention?, :to_pending_mention?, :to_approved_mention?, :to_rejected_mention?, :to_accrued_mention?,
                  :to_canceled_mention?, :to_removed_mention? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `pending_mention`' do
      let(:from_status) { 'pending_mention' }

      permissions :to_draft_mention?, :to_pending_mention?, :to_approved_mention?, :to_rejected_mention?, :to_accrued_mention?,
                  :to_canceled_mention?, :to_removed_mention? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `approved_mention`' do
      let(:from_status) { 'approved_mention' }

      permissions :to_draft_mention?, :to_pending_mention?, :to_approved_mention?, :to_rejected_mention?, :to_accrued_mention?,
                  :to_canceled_mention?, :to_removed_mention? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `rejected_mention`' do
      let(:from_status) { 'rejected_mention' }

      permissions :to_draft_mention?, :to_pending_mention?, :to_approved_mention?, :to_rejected_mention?, :to_accrued_mention?,
                  :to_canceled_mention?, :to_removed_mention? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `accrued_mention`' do
      let(:from_status) { 'accrued_mention' }

      permissions :to_draft_mention?, :to_pending_mention?, :to_approved_mention?, :to_rejected_mention?, :to_accrued_mention?,
                  :to_canceled_mention?, :to_removed_mention? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `canceled_mention`' do
      let(:from_status) { 'canceled_mention' }

      permissions :to_draft_mention?, :to_pending_mention?, :to_approved_mention?, :to_rejected_mention?, :to_accrued_mention?,
                  :to_canceled_mention?, :to_removed_mention? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `removed_mention`' do
      let(:from_status) { 'removed_mention' }

      permissions :to_draft_mention?, :to_pending_mention?, :to_approved_mention?, :to_rejected_mention?, :to_accrued_mention?,
                  :to_canceled_mention?, :to_removed_mention? do
        it { is_expected.to permit(user, policy_context) }
      end
    end
  end
end
