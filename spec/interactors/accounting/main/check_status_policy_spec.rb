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

      permissions :to_payed?, :to_processing? do
        it { is_expected.not_to permit(user, policy_context) }
      end

      permissions :to_requested? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `requested`' do
      let(:from_status) { 'requested' }

      permissions :to_payed?, :to_processing? do
        it { is_expected.not_to permit(user, policy_context) }
      end

      permissions :to_requested? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `processing`' do
      let(:from_status) { 'processing' }

      permissions :to_requested?, :to_processing?, :to_payed? do
        it { is_expected.not_to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `payed`' do
      let(:from_status) { 'payed' }

      permissions :to_requested?, :to_processing?, :to_payed? do
        it { is_expected.not_to permit(user, policy_context) }
      end
    end
  end

  context 'with admin' do
    let(:user) { build(:user, role: :admin) }

    context 'when `from_status` is `nil`' do
      let(:from_status) { nil }

      permissions :to_requested?, :to_processing?, :to_payed? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `requested`' do
      let(:from_status) { 'requested' }

      permissions :to_requested?, :to_processing?, :to_payed? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `processing`' do
      let(:from_status) { 'processing' }

      permissions :to_requested?, :to_processing?, :to_payed? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `from_status` is `payed`' do
      let(:from_status) { 'pending' }

      permissions :to_requested?, :to_processing?, :to_payed? do
        it { is_expected.to permit(user, policy_context) }
      end
    end
  end
end
