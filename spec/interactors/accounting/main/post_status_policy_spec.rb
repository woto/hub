# frozen_string_literal: true

require 'rails_helper'

describe Accounting::Main::PostStatusPolicy, type: :policy do
  subject { described_class }

  let(:policy_context) { Accounting::Main::StatusContext.new(record: build(:post), from_status: from_status) }

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

      permissions :to_approved_post?, :to_rejected_post?, :to_accrued_post?, :to_canceled_post?, :to_removed_post? do
        it { is_expected.not_to permit(user, policy_context) }
      end

      permissions :to_draft_post?, :to_pending_post? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `draft_post`' do
      let(:from_status) { 'draft_post' }

      permissions :to_approved_post?, :to_rejected_post?, :to_accrued_post?, :to_canceled_post? do
        it { is_expected.not_to permit(user, policy_context) }
      end

      permissions :to_draft_post?, :to_pending_post?, :to_removed_post? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `pending_post`' do
      let(:from_status) { 'pending_post' }

      permissions :to_approved_post?, :to_rejected_post?, :to_accrued_post?, :to_canceled_post? do
        it { is_expected.not_to permit(user, policy_context) }
      end

      permissions :to_draft_post?, :to_pending_post?, :to_removed_post? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `approved_post`' do
      let(:from_status) { 'approved_post' }

      permissions :to_draft_post?, :to_pending_post?, :to_approved_post?, :to_rejected_post?, :to_accrued_post?,
                  :to_canceled_post?, :to_removed_post? do
        it { is_expected.not_to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `rejected_post`' do
      let(:from_status) { 'rejected_post' }

      permissions :to_draft_post?, :to_pending_post?, :to_removed_post? do
        it { is_expected.to permit(user, policy_context) }
      end

      permissions :to_approved_post?, :to_rejected_post?, :to_accrued_post?, :to_canceled_post? do
        it { is_expected.not_to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `accrued_post`' do
      let(:from_status) { 'accrued_post' }

      permissions :to_draft_post?, :to_pending_post?, :to_approved_post?, :to_rejected_post?, :to_accrued_post?,
                  :to_canceled_post?, :to_removed_post? do
        it { is_expected.not_to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `canceled_post`' do
      let(:from_status) { 'canceled_post' }

      permissions :to_draft_post?, :to_pending_post?, :to_approved_post?, :to_rejected_post?, :to_accrued_post?,
                  :to_canceled_post?, :to_removed_post? do
        it { is_expected.not_to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `removed_post`' do
      let(:from_status) { 'removed_post' }

      permissions :to_draft_post?, :to_pending_post?, :to_approved_post?, :to_rejected_post?, :to_accrued_post?,
                  :to_canceled_post?, :to_removed_post? do
        it { is_expected.not_to permit(user, policy_context) }
      end
    end
  end

  context 'with admin' do
    let(:user) { build(:user, role: :admin) }

    context 'when `from_status` is `nil`' do
      let(:from_status) { nil }

      permissions :to_draft_post?, :to_pending_post?, :to_approved_post?, :to_rejected_post?, :to_accrued_post?,
                  :to_canceled_post?, :to_removed_post? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `draft_post`' do
      let(:from_status) { 'draft_post' }

      permissions :to_draft_post?, :to_pending_post?, :to_approved_post?, :to_rejected_post?, :to_accrued_post?,
                  :to_canceled_post?, :to_removed_post? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `pending_post`' do
      let(:from_status) { 'pending_post' }

      permissions :to_draft_post?, :to_pending_post?, :to_approved_post?, :to_rejected_post?, :to_accrued_post?,
                  :to_canceled_post?, :to_removed_post? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `approved_post`' do
      let(:from_status) { 'approved_post' }

      permissions :to_draft_post?, :to_pending_post?, :to_approved_post?, :to_rejected_post?, :to_accrued_post?,
                  :to_canceled_post?, :to_removed_post? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `rejected_post`' do
      let(:from_status) { 'rejected_post' }

      permissions :to_draft_post?, :to_pending_post?, :to_approved_post?, :to_rejected_post?, :to_accrued_post?,
                  :to_canceled_post?, :to_removed_post? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `accrued_post`' do
      let(:from_status) { 'accrued_post' }

      permissions :to_draft_post?, :to_pending_post?, :to_approved_post?, :to_rejected_post?, :to_accrued_post?,
                  :to_canceled_post?, :to_removed_post? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `canceled_post`' do
      let(:from_status) { 'canceled_post' }

      permissions :to_draft_post?, :to_pending_post?, :to_approved_post?, :to_rejected_post?, :to_accrued_post?,
                  :to_canceled_post?, :to_removed_post? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `removed_post`' do
      let(:from_status) { 'removed_post' }

      permissions :to_draft_post?, :to_pending_post?, :to_approved_post?, :to_rejected_post?, :to_accrued_post?,
                  :to_canceled_post?, :to_removed_post? do
        it { is_expected.to permit(user, policy_context) }
      end
    end
  end
end
