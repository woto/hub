# frozen_string_literal: true

# Used in User model
module Authenticatable
  extend ActiveSupport::Concern

  included do
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable,
           :confirmable, :lockable, :timeoutable, :trackable

    has_many :identities

    protected

    def password_required?
      super && !oauthenticable
    end

    def email_required?
      super && !oauthenticable
    end

    def send_email_changed_notification
      unless email_before_last_save.nil?
        send_devise_notification(:email_changed, to: email_before_last_save)
      end
    end
  end
end
