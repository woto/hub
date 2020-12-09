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
class User < ApplicationRecord
  include Elasticable
  # include Elasticsearch::Model::Callbacks
  index_name "#{Rails.env}.users"

  enum role: { user: 0, manager: 1, admin: 2 }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_one :profile, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :identities, dependent: :destroy
  has_many :workspaces, dependent: :destroy
  has_one_attached :avatar
  has_many :accounts, as: :subject
  has_many :checks

  before_create :set_default_role

  def as_indexed_json(options={})
    {
      id: id,
      confirmation_sent_at: confirmation_sent_at,
      confirmation_token: confirmation_token,
      confirmed_at: confirmed_at,
      current_sign_in_at: current_sign_in_at,
      current_sign_in_ip: current_sign_in_ip&.to_s,
      email: email,
      encrypted_password: encrypted_password,
      failed_attempts: failed_attempts,
      last_sign_in_at: last_sign_in_at,
      last_sign_in_ip: last_sign_in_ip&.to_s,
      locked_at: locked_at,
      remember_created_at: remember_created_at,
      reset_password_sent_at: reset_password_sent_at,
      reset_password_token: reset_password_token,
      role: role,
      sign_in_count: sign_in_count,
      unconfirmed_email: unconfirmed_email,
      unlock_token: unlock_token,
      created_at: created_at,
      updated_at: updated_at,
      profile_id: profile&.id,
      profile_name: profile&.name,
      profile_time_zone: profile&.time_zone,
      profile_bio: profile&.bio,
      profile_languages: profile&.languages,
      profile_messengers: profile&.messengers,
      profile_created_at: profile&.created_at,
      profile_updated_at: profile&.updated_at
    }
  end

  def set_default_role
    self.role ||= 'user'
  end

  def to_label
    email
  end
end
