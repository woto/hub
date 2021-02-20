# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer
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
      expect(content).to include("https://nv6.ru/auth/password/edit?reset_password_token=#{reset_password_token}")
    end
  end
end
