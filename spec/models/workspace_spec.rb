# frozen_string_literal: true

# == Schema Information
#
# Table name: workspaces
#
#  id         :bigint           not null, primary key
#  controller :string
#  is_default :boolean          default(FALSE), not null
#  name       :string
#  path       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_workspaces_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

describe Workspace, type: :model do
  it { is_expected.to belong_to(:user).counter_cache(true).touch(true) }
  it { is_expected.to validate_presence_of(:name) }

  specify {
    expect(subject).to validate_inclusion_of(:controller).in_array(
      %w[
        tables/accounts tables/checks tables/favorites tables/feeds tables/help tables/news tables/offers
        tables/post_categories tables/posts tables/transactions tables/users
      ]
    )
  }

  describe '#is_default' do
    let(:user) { create(:user) }

    context 'when created workspace `is_default` with same user and controller' do
      let!(:workspace) { create(:workspace, user: user, controller: 'tables/news', is_default: true)}

      it 'flushes `is_default` flag on another workspaces' do
        expect do
          create(:workspace, user: user, controller: 'tables/news', is_default: true)
        end.to(
          change { workspace.reload.is_default }.to(false)
        )
      end
    end

    context 'when created workspace `is_default` with same user but not the same controller' do
      let!(:workspace) { create(:workspace, user: user, controller: 'tables/posts', is_default: true)}

      it 'does not flush `is_default` flag on another workspaces' do
        expect do
          create(:workspace, user: user, controller: 'tables/news', is_default: true)
        end.not_to(
          change { workspace.reload.is_default }
        )
      end
    end

    context 'when created workspace `is_default` with same controller but not the same user' do
      let!(:workspace) { create(:workspace, controller: 'tables/posts', is_default: true)}

      it 'does not flush `is_default` flag on another workspace' do
        expect do
          create(:workspace, user: user, controller: 'tables/posts', is_default: true)
        end.not_to(
          change { workspace.reload.is_default }
        )
      end
    end
  end
end
