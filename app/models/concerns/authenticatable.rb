# frozen_string_literal: true

# Used in User model
module Authenticatable
  extend ActiveSupport::Concern

  included do
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable,
           :confirmable, :lockable, :timeoutable, :trackable

    has_many :access_grants,
             class_name: 'Doorkeeper::AccessGrant',
             foreign_key: :resource_owner_id,
             dependent: :delete_all # or :destroy if you need callbacks

    has_many :access_tokens,
             class_name: 'Doorkeeper::AccessToken',
             foreign_key: :resource_owner_id,
             dependent: :delete_all # or :destroy if you need callbacks

    has_many :identities

    protected

    def password_required?
      super && !oauthenticable
    end

    def email_required?
      super && !oauthenticable
    end
  end
end