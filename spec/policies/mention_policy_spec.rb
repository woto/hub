# frozen_string_literal: true

require 'rails_helper'

# NOTE: Responsible admin needed for creation in the right status.
# Treat it as a stub. It does not affect to the tested parts.
describe MentionPolicy, responsible: :admin do
  subject { described_class }

  describe '#permitted_attributes' do
    subject { described_class.new(user, nil).permitted_attributes }

    let(:permitted_attributes) do
      [:published_at, :sentiment, :url, :image,
       { kinds: [], entity_ids: [], tags: [], advertiser_ext_ids: [], topics_attributes: [] }]
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

  # everybody can index mentions
  describe 'index?' do
    permissions :index? do
      it { is_expected.to permit(nil, nil) }
    end
  end

  # everybody can create mentions
  describe 'create?' do
    permissions :create? do
      it { is_expected.to permit(nil, nil) }
    end
  end

  context 'with user' do
    let(:user) { create(:user) }
    let(:policy_context) { create(:mention, user: user) }

    permissions :update?, :show?, :destroy? do
      it { is_expected.to permit(user, policy_context) }
    end
  end

  context 'with another user' do
    let(:user) { create(:user) }
    let(:policy_context) { create(:mention, user: user) }

    permissions :update?, :show?, :destroy? do
      it { is_expected.not_to permit(create(:user), policy_context) }
    end
  end

  context 'with admin' do
    let(:user) { create(:user) }
    let(:policy_context) { create(:mention, user: user) }

    permissions :update?, :show?, :destroy? do
      it { is_expected.to permit(create(:user, role: :admin), policy_context) }
    end
  end
end
