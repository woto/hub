# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  checks_count           :integer          default(0)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  favorites_count        :integer          default(0)
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  locked_at              :datetime
#  posts_count            :integer          default(0)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("user")
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
require 'rails_helper'

describe User, type: :model do
  it_behaves_like 'elasticable'
  it_behaves_like 'logidzable'

  it { is_expected.to have_db_index(:confirmation_token).unique }
  it { is_expected.to have_db_index(:email) }
  it { is_expected.to have_db_index(:reset_password_token).unique }
  it { is_expected.to have_db_index(:unlock_token).unique }
  it { expect(subject).to define_enum_for(:role).with_values(%i[user manager admin]) }
  it { is_expected.to have_one_attached(:avatar) }
  it { is_expected.to have_one(:profile).dependent(:destroy) }
  it { is_expected.to have_many(:posts).dependent(:destroy) }
  it { is_expected.to have_many(:identities).dependent(:destroy) }
  it { is_expected.to have_many(:workspaces).dependent(:destroy) }
  it { is_expected.to have_many(:accounts) }
  it { is_expected.to have_many(:checks) }

  describe '#set_default_role' do
    subject { user.role }

    context 'when `role` value do not passed to user creation' do
      let(:user) { create(:user) }

      it { is_expected.to eq('user') }
    end

    context 'when `role` value passed to user creation' do
      let(:user) { create(:user, role: :manager) }

      it { is_expected.to eq('manager') }
    end
  end

  describe '#to_label' do
    subject { user.to_label }

    let(:user) { create(:user, email: 'foo@bar.com') }

    it 'returns correct label for user' do
      expect(subject).to eq('foo@bar.com')
    end
  end

  describe '#as_indexed_json' do
    subject { user.as_indexed_json }
    let(:user) { create(:user) }

    # TODO: add more attributes later
    it { is_expected.to include(id: user.id)}
  end

  context 'with confirmed email' do
    let(:user) { create(:user) }

    it { expect(user).to be_confirmed }

    it 'receives confirmation email when changes his email' do
      expect do
        user.update(email: user.email.prepend('changed_'))
      end.to change(ActionMailer::Base.deliveries, :count).by(2)
    end

    it 'contains correct link in reset password instuctions' do
      reset_password_token = user.send_reset_password_instructions

      content = ActionMailer::Base.deliveries.first.body.encoded
      expect(content).to include("/auth/password/edit?reset_password_token=#{reset_password_token}")
    end
  end
end
