# frozen_string_literal: true

require 'rails_helper'

describe EntityPolicy do
  subject { described_class }

  describe '#permitted_attributes' do
    subject { described_class.new(user, nil).permitted_attributes }

    let(:permitted_attributes) do
      [:title, :picture, :image, { aliases: [] }]
    end

    context 'with user' do
      let(:user) { create(:user) }
      let(:user_permitted_attributes) { permitted_attributes }

      it { is_expected.to match_array(user_permitted_attributes) }
    end

    context 'with admin' do
      let(:user) { create(:user, role: :admin) }
      let(:admin_permitted_attributes) { permitted_attributes.append(:user_id) }

      it { is_expected.to match_array(admin_permitted_attributes) }
    end
  end

  # everybody can index entities
  describe 'index?' do
    permissions :index? do
      it { is_expected.to permit(nil, nil) }
    end
  end

  # everybody can create entities
  describe 'create?' do
    permissions :create? do
      it { is_expected.to permit(nil, nil) }
    end
  end

  # everybody can show entities
  describe 'show?' do
    permissions :show? do
      it { is_expected.to permit(nil, nil) }
    end
  end

  context 'with user' do
    let(:user) { create(:user) }
    let(:policy_context) { create(:entity, user: user) }

    permissions :update?, :destroy? do
      it { is_expected.to permit(user, policy_context) }
    end
  end

  context 'with another user' do
    let(:user) { create(:user) }
    let(:policy_context) { create(:entity, user: user) }

    permissions :update?, :destroy? do
      it { is_expected.not_to permit(create(:user), policy_context) }
    end
  end

  context 'with admin' do
    let(:user) { create(:user) }
    let(:policy_context) { create(:entity, user: user) }

    permissions :update?, :destroy? do
      it { is_expected.to permit(create(:user, role: :admin), policy_context) }
    end
  end
end
