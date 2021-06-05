# frozen_string_literal: true

require 'rails_helper'

# NOTE: Responsible admin needed for creation in the right status.
# Treat it as a stub. It does not affect to the tested parts.
describe PostPolicy, responsible: :admin do
  subject { described_class }

  context 'with user' do
    let(:user) { create(:user) }
    let(:policy_context) { create(:post, user: user, status: status) }

    # anybody can create posts
    describe 'create?' do
      permissions :create? do
        it { is_expected.to permit(user, nil) }
      end
    end

    # anybody can index posts
    describe 'index?' do
      permissions :index? do
        it { is_expected.to permit(user, nil) }
      end
    end

    context 'when `status` is `draft_post`' do
      let(:status) { :draft_post }

      permissions :update?, :show?, :destroy? do
        it { is_expected.to permit(user, policy_context) }
      end

      # another user can not get access
      permissions :update?, :show?, :destroy? do
        it { is_expected.not_to permit(create(:user), policy_context) }
      end
    end

    context 'when `status` is `pending_post`' do
      let(:status) { :pending_post }

      permissions :update?, :show?, :destroy? do
        it { is_expected.to permit(user, policy_context) }
      end

      # another user can not get access
      permissions :update?, :show?, :destroy? do
        it { is_expected.not_to permit(create(:user), policy_context) }
      end
    end

    context 'when `status` is `approved_post`' do
      let(:status) { :approved_post }

      permissions :show? do
        it { is_expected.to permit(user, policy_context) }
      end

      permissions :update?, :destroy? do
        it { is_expected.not_to permit(user, policy_context) }
      end

      # another user can not get access
      permissions :update?, :show?, :destroy? do
        it { is_expected.not_to permit(create(:user), policy_context) }
      end
    end

    context 'when `status` is `rejected_post`' do
      let(:status) { :rejected_post }

      permissions :update?, :show?, :destroy? do
        it { is_expected.to permit(user, policy_context) }
      end

      # another user can not get access
      permissions :update?, :show?, :destroy? do
        it { is_expected.not_to permit(create(:user), policy_context) }
      end
    end

    context 'when `status` is `accrued_post`' do
      let(:status) { :accrued_post }

      permissions :show? do
        it { is_expected.to permit(user, policy_context) }
      end

      permissions :update?, :destroy? do
        it { is_expected.not_to permit(user, policy_context) }
      end

      # another user can not get access
      permissions :update?, :show?, :destroy? do
        it { is_expected.not_to permit(create(:user), policy_context) }
      end
    end

    context 'when `status` is `canceled_post`' do
      let(:status) { :canceled_post }

      permissions :show? do
        it { is_expected.to permit(user, policy_context) }
      end

      permissions :update?, :destroy? do
        it { is_expected.not_to permit(user, policy_context) }
      end

      # another user can not get access
      permissions :update?, :show?, :destroy? do
        it { is_expected.not_to permit(create(:user), policy_context) }
      end
    end

    context 'when `status` is `removed_post`' do
      let(:status) { :removed_post }

      permissions :show? do
        it { is_expected.to permit(user, policy_context) }
      end

      permissions :update?, :destroy? do
        it { is_expected.not_to permit(user, policy_context) }
      end

      # another user can not get access
      permissions :update?, :show?, :destroy? do
        it { is_expected.not_to permit(create(:user), policy_context) }
      end
    end
  end

  context 'with admin' do
    let(:user) { create(:user, role: :admin) }
    let(:policy_context) { create(:post, user: user, status: status) }

    context 'when `status` is `draft_post`' do
      let(:status) { :draft_post }

      permissions :update?, :create?, :show?, :destroy? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `status` is `pending_post`' do
      let(:status) { :pending_post }

      permissions :update?, :create?, :show?, :destroy? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `status` is `approved_post`' do
      let(:status) { :approved_post }

      permissions :update?, :create?, :show?, :destroy? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `status` is `rejected_post`' do
      let(:status) { :rejected_post }

      permissions :update?, :create?, :show?, :destroy? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `status` is `accrued_post`' do
      let(:status) { :accrued_post }

      permissions :update?, :create?, :show?, :destroy? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `status` is `canceled_post`' do
      let(:status) { :canceled_post }

      permissions :update?, :create?, :show?, :destroy? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `status` is `removed_post`' do
      let(:status) { :removed_post }

      permissions :update?, :create?, :show?, :destroy? do
        it { is_expected.to permit(user, policy_context) }
      end
    end
  end
end
