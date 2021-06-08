# frozen_string_literal: true

require 'rails_helper'

# NOTE: Responsible admin needed for creation in the right status.
# Treat it as a stub. It does not affect to the tested parts.
describe CheckPolicy, responsible: :admin do
  subject { described_class }

  before do
    allow_any_instance_of(Check).to receive(:check_amount)
  end

  describe '#permitted_attributes' do
    subject { described_class.new(user, nil).permitted_attributes }

    let(:permitted_attributes) do
      %i[
        amount currency status
      ]
    end

    context 'with user' do
      let(:user) { create(:user) }
      let(:user_permitted_attributes) { permitted_attributes }

      it { is_expected.to eq(user_permitted_attributes) }
    end

    context 'with admin' do
      let(:user) { create(:user, role: :admin) }
      let(:admin_permitted_attributes) { permitted_attributes.append(:user_id) }

      it { is_expected.to eq(admin_permitted_attributes) }
    end
  end

  # everybody can create checks
  describe 'create?' do
    permissions :create? do
      it { is_expected.to permit(nil, nil) }
    end
  end

  # everybody can index checks
  describe 'index?' do
    permissions :index? do
      it { is_expected.to permit(nil, nil) }
    end
  end

  context 'with user' do
    let(:user) { create(:user) }
    let(:policy_context) { create(:check, user: user, status: status) }

    context 'when `status` is `pending_check`' do
      let(:status) { :pending_check }

      permissions :update?, :show?, :destroy? do
        it { is_expected.to permit(user, policy_context) }
      end

      # another user can not get access
      permissions :update?, :show?, :destroy? do
        it { is_expected.not_to permit(create(:user), policy_context) }
      end
    end

    context 'when `status` is `approved_check`' do
      let(:status) { :approved_check }

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

    context 'when `status` is `payed_check`' do
      let(:status) { :payed_check }

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

    context 'when `status` is `removed_check`' do
      let(:status) { :removed_check }

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
    let(:policy_context) { create(:check, user: user, status: status) }

    context 'when `status` is `pending_check`' do
      let(:status) { :pending_check }

      permissions :update?, :show?, :destroy? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `status` is `approved_check`' do
      let(:status) { :approved_check }

      permissions :update?, :show?, :destroy? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `status` is `payed_check`' do
      let(:status) { :payed_check }

      permissions :update?, :show?, :destroy? do
        it { is_expected.to permit(user, policy_context) }
      end
    end

    context 'when `status` is `removed_check`' do
      let(:status) { :removed_check }

      permissions :update?, :show?, :destroy? do
        it { is_expected.to permit(user, policy_context) }
      end
    end
  end
end
