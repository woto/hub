# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  api_key                :string
#  checks_count           :integer          default(0), not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  entities_count         :integer          default(0), not null
#  failed_attempts        :integer          default(0), not null
#  favorites_count        :integer          default(0), not null
#  identities_count       :integer          default(0), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  locked_at              :datetime
#  posts_count            :integer          default(0), not null
#  profiles_count         :integer          default(0), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("user"), not null
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  workspaces_count       :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_api_key               (api_key) UNIQUE
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
  it { is_expected.to have_one(:avatar) }
  it { is_expected.to have_one(:profile).dependent(:restrict_with_exception) }
  it { is_expected.to have_many(:posts).dependent(:restrict_with_exception) }
  it { is_expected.to have_many(:identities).dependent(:restrict_with_exception) }
  it { is_expected.to have_many(:workspaces).dependent(:restrict_with_exception) }
  it { is_expected.to have_many(:accounts).dependent(:restrict_with_exception) }
  it { is_expected.to have_many(:checks).dependent(:restrict_with_exception) }
  it { is_expected.to have_many(:favorites).dependent(:restrict_with_exception) }
  it { is_expected.to have_many(:entities).dependent(:restrict_with_exception) }

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
    it { is_expected.to include(id: user.id) }
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

    context 'when creates user' do
      it 'generates api_key to him' do
        user = nil
        expect do
          user = described_class.create(email: 'foo@bar.com', password: '123123123')
        end.to change(described_class, :count)

        expect(user.api_key).to be_a(String)
        expect(user.api_key).not_to be_empty
      end
    end

    context 'when saved user saves' do
      let!(:user) { create(:user, role: :user) }

      it 'does not regenerate his api_key' do
        expect do
          expect do
            user.update(role: :manager)
          end.to change(user, :updated_at)
        end.not_to change(user, :api_key)
      end
    end
  end
end
